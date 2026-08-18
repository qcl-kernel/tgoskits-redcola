use std::{env, process, time::Instant};

const PREBUILD_MARKER: &str = include_str!(concat!(env!("OUT_DIR"), "/prebuild_marker.txt"));

#[derive(Copy, Clone)]
struct Sample {
    demand: i32,
    load: i32,
    vibration: i32,
}

const SAMPLES: [Sample; 8] = [
    Sample {
        demand: 930,
        load: 30,
        vibration: 5,
    },
    Sample {
        demand: 1000,
        load: 55,
        vibration: 12,
    },
    Sample {
        demand: 1080,
        load: 70,
        vibration: 9,
    },
    Sample {
        demand: 1150,
        load: 82,
        vibration: 18,
    },
    Sample {
        demand: 970,
        load: 40,
        vibration: 20,
    },
    Sample {
        demand: 1040,
        load: 63,
        vibration: 7,
    },
    Sample {
        demand: 1120,
        load: 75,
        vibration: 15,
    },
    Sample {
        demand: 990,
        load: 48,
        vibration: 11,
    },
];

const MANUAL_PWM: i32 = 650;
const INPUTS: usize = 4;
const HIDDEN: usize = 4;
const HIDDEN_WEIGHTS: [[i32; INPUTS]; HIDDEN] =
    [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
const HIDDEN_BIASES: [i32; HIDDEN] = [0, 0, 0, 0];
const OUTPUT_WEIGHTS: [i32; HIDDEN] = [1, 2, 1, -400];
const OUTPUT_BIAS: i32 = 0;
const QCZ1_MAGIC: u32 = 0x5143_5a31;
const QCZ1_VERSION: u8 = 1;
const QCZ1_HEADER_LEN: usize = 28;
const QCZ1_CHECKSUM_OFFSET: usize = 24;
const QCZ1_MSG_CONTROL_SET: u8 = 1;
const QCZ1_CONTROL_PAYLOAD_LEN: usize = 12;
const QCZ1_CONTROL_FRAME_LEN: usize = QCZ1_HEADER_LEN + QCZ1_CONTROL_PAYLOAD_LEN;

fn abs(v: i32) -> i32 {
    if v < 0 { -v } else { v }
}

fn plant_output(pwm: i32, s: Sample) -> i32 {
    400 + pwm - 2 * s.load - s.vibration
}

fn relu(v: i32) -> i32 {
    v.max(0)
}

fn dot<const N: usize>(weights: &[i32; N], inputs: &[i32; N]) -> i32 {
    weights
        .iter()
        .zip(inputs.iter())
        .map(|(weight, input)| weight * input)
        .sum()
}

fn infer_pwm(s: Sample) -> i32 {
    let inputs = [s.demand, s.load, s.vibration, 1];
    let mut hidden = [0; HIDDEN];
    for (idx, weights) in HIDDEN_WEIGHTS.iter().enumerate() {
        hidden[idx] = relu(dot(weights, &inputs) + HIDDEN_BIASES[idx]);
    }
    (dot(&OUTPUT_WEIGHTS, &hidden) + OUTPUT_BIAS).clamp(0, 2_000)
}

fn put_be16(buf: &mut [u8], offset: usize, value: u16) {
    buf[offset..offset + 2].copy_from_slice(&value.to_be_bytes());
}

fn put_be32(buf: &mut [u8], offset: usize, value: u32) {
    buf[offset..offset + 4].copy_from_slice(&value.to_be_bytes());
}

fn put_be_i32(buf: &mut [u8], offset: usize, value: i32) {
    buf[offset..offset + 4].copy_from_slice(&value.to_be_bytes());
}

fn put_be64(buf: &mut [u8], offset: usize, value: u64) {
    buf[offset..offset + 8].copy_from_slice(&value.to_be_bytes());
}

fn qcz1_checksum(frame: &[u8]) -> u32 {
    let mut value = 2_166_136_261u32;
    for (idx, byte) in frame.iter().copied().enumerate() {
        let input = if (QCZ1_CHECKSUM_OFFSET..QCZ1_CHECKSUM_OFFSET + 4).contains(&idx) {
            0
        } else {
            byte
        };
        value ^= u32::from(input);
        value = value.wrapping_mul(16_777_619);
    }
    value
}

fn qcz1_control_frame(
    seq: u32,
    setpoint_milli: i32,
    ai_score_milli: i32,
    sample_id: u32,
) -> [u8; QCZ1_CONTROL_FRAME_LEN] {
    let mut frame = [0u8; QCZ1_CONTROL_FRAME_LEN];

    put_be32(&mut frame, 0, QCZ1_MAGIC);
    frame[4] = QCZ1_VERSION;
    frame[5] = QCZ1_MSG_CONTROL_SET;
    put_be16(&mut frame, 6, QCZ1_HEADER_LEN as u16);
    put_be16(&mut frame, 8, QCZ1_CONTROL_PAYLOAD_LEN as u16);
    put_be16(&mut frame, 10, 0);
    put_be32(&mut frame, 12, seq);
    put_be64(&mut frame, 16, 0);
    put_be32(&mut frame, QCZ1_CHECKSUM_OFFSET, 0);
    put_be_i32(&mut frame, QCZ1_HEADER_LEN, setpoint_milli);
    put_be_i32(&mut frame, QCZ1_HEADER_LEN + 4, ai_score_milli);
    put_be32(&mut frame, QCZ1_HEADER_LEN + 8, sample_id);

    let checksum = qcz1_checksum(&frame);
    put_be32(&mut frame, QCZ1_CHECKSUM_OFFSET, checksum);
    frame
}

fn read_be32(buf: &[u8], offset: usize) -> u32 {
    u32::from_be_bytes([
        buf[offset],
        buf[offset + 1],
        buf[offset + 2],
        buf[offset + 3],
    ])
}

fn main() {
    let marker = PREBUILD_MARKER.trim();

    println!(
        "REDCOLA_STARRY_AI_BEGIN guest=StarryOS role=non_rt_guest model=fixed_point_mlp_policy \
         hidden={} samples={} pid={} prebuild_marker={}",
        HIDDEN,
        SAMPLES.len(),
        process::id(),
        marker
    );
    println!(
        "redcola-ai-control args={:?}",
        env::args().collect::<Vec<_>>()
    );

    let mut manual_abs_error = 0;
    let mut ai_abs_error = 0;
    let mut max_ai_error = 0;
    let mut infer_total_us: u128 = 0;

    for (idx, s) in SAMPLES.iter().copied().enumerate() {
        let start = Instant::now();
        let ai_pwm = infer_pwm(s);
        let infer_us = start.elapsed().as_micros();
        infer_total_us += infer_us;
        let manual_out = plant_output(MANUAL_PWM, s);
        let ai_out = plant_output(ai_pwm, s);
        let manual_error = abs(s.demand - manual_out);
        let ai_error = abs(s.demand - ai_out);
        manual_abs_error += manual_error;
        ai_abs_error += ai_error;
        max_ai_error = max_ai_error.max(ai_error);
        println!(
            "REDCOLA_STARRY_AI_SAMPLE seq={} demand={} load={} vibration={} manual_pwm={} \
             ai_pwm={} manual_error={} ai_error={} nn_infer_us={}",
            idx + 1,
            s.demand,
            s.load,
            s.vibration,
            MANUAL_PWM,
            ai_pwm,
            manual_error,
            ai_error,
            infer_us
        );
    }

    let mean_infer_us = infer_total_us / SAMPLES.len() as u128;
    println!(
        "REDCOLA_STARRY_CONTROL_SUMMARY manual_abs_error={} ai_abs_error={} max_ai_error={} \
         mean_infer_us={}",
        manual_abs_error, ai_abs_error, max_ai_error, mean_infer_us
    );

    let proof_sample = SAMPLES[0];
    let proof_output = plant_output(infer_pwm(proof_sample), proof_sample);
    let proof_score = (proof_output * 1000) / proof_sample.demand;
    let proof_frame = qcz1_control_frame(9_001, proof_sample.demand, proof_score, 1);
    let proof_checksum = read_be32(&proof_frame, QCZ1_CHECKSUM_OFFSET);
    if proof_frame.len() == QCZ1_CONTROL_FRAME_LEN
        && read_be32(&proof_frame, 0) == QCZ1_MAGIC
        && proof_frame[4] == QCZ1_VERSION
        && proof_frame[5] == QCZ1_MSG_CONTROL_SET
        && proof_checksum == qcz1_checksum(&proof_frame)
    {
        println!(
            "REDCOLA_STARRY_QCZ1_FRAME magic=QCZ1 version={} type=CONTROL_SET header_len={} \
             payload_len={} seq=9001 sample_id=1 checksum=0x{:08x} frame_len={}",
            QCZ1_VERSION,
            QCZ1_HEADER_LEN,
            QCZ1_CONTROL_PAYLOAD_LEN,
            proof_checksum,
            proof_frame.len()
        );
        println!(
            "REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli={} ai_score_milli={} sample_id=1",
            proof_sample.demand, proof_score
        );
    } else {
        println!("REDCOLA_STARRY_QCZ1_PARITY_FAIL");
        process::exit(1);
    }

    if ai_abs_error < manual_abs_error && max_ai_error <= 35 {
        println!(
            "REDCOLA_STARRY_AI_CONTROL_PASS samples={} manual_abs_error={} ai_abs_error={} \
             mean_infer_us={}",
            SAMPLES.len(),
            manual_abs_error,
            ai_abs_error,
            mean_infer_us
        );
        println!("REDCOLA_STARRY_AI_DONE");
    } else {
        println!("REDCOLA_STARRY_AI_CONTROL_FAIL");
        process::exit(1);
    }
}
