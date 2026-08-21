# Redcola StarryOS AI Control Demo

This case runs a small deterministic AI-control workload as a Linux-user-mode
program inside the StarryOS QEMU guest. It is intended as bonus evidence for the
Quancheng Laboratory 2026 AxVisor contest, where StarryOS is preferred over a
standard Linux non-RT guest.

## Reviewer Quick Evidence

| Item | Evidence |
| --- | --- |
| Contest role | StarryOS non-RT guest bonus evidence for the redcola AxVisor contest submission. |
| Private repo PR | Submitted as PR #2 in `qcl-kernel/tgoskits-redcola`. |
| Main delivery link | The AxVisor Linux/RTOS mixed-system delivery remains in PR #1 under `os/axvisor/contest/quancheng2026/`. |
| Runtime environment | StarryOS QEMU guest runs the AI-control app as a Linux-user-mode program. |
| QEMU machine | AArch64 `virt,gic-version=3`, matching the GIC route expected by current StarryOS on QEMU. |
| AI model | Deterministic fixed-point MLP policy with 4 inputs and 4 hidden units. |
| QCZ1 protocol parity | The StarryOS guest builds and self-checks a QCZ1 `CONTROL_SET` frame matching the main delivery protocol shape. |
| Scorecard | `SCORECARD.md` maps the bonus evidence to contest scoring items and states the review boundary. |
| Validation marker | `REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0`. |
| Protocol marker | `REDCOLA_STARRY_QCZ1_PARITY_PASS`. |
| Final runner marker | `REDCOLA_STARRY_AI_DONE`. |

For the shortest score-oriented review path, start with
`REVIEWER-QUICKSTART.md`, then use `SCORECARD.md` and `VALIDATION.md` for the
full boundary and evidence details.

This PR is intentionally scoped as a StarryOS bonus artifact. It complements,
but does not replace, the main AxVisor Linux/RTOS communication and AI closed
loop delivered by PR #1.

## Scorecard Boundary

| Contest item | This bonus PR evidence | Boundary |
| --- | --- | --- |
| StarryOS instead of standard Linux | StarryOS QEMU runs the deterministic AI-control workload and prints PASS/DONE markers. | This is bonus evidence for the non-RT guest direction. The main AxVisor Linux/RTOS closed loop remains in PR #1. |
| AI model inference | The guest program runs a fixed-point 4-input, 4-hidden-unit MLP policy. | The model is intentionally tiny so it is deterministic, inspectable and easy to reproduce in StarryOS. |
| Control baseline comparison | The program compares fixed manual PWM against the MLP policy over eight samples. | This validates AI control behavior inside StarryOS, but it does not claim RTOS network control by itself. |
| QCZ1 protocol framing | The program builds and validates a deterministic QCZ1 `CONTROL_SET` frame with magic, version, type, header length, payload length, sequence, checksum and 12-byte control payload. | This is protocol-shape parity with PR #1, not a StarryOS-to-RTOS network claim. |
| StarryOS syscall/Linux ABI improvement | No syscall or Linux ABI patch is claimed in this branch. | Avoids mixing the separate syscall bonus with this AI-control demo. |

For final submission, cite this PR together with the main AxVisor artifact PR:

```text
Main AxVisor artifact: qcl-kernel/tgoskits-redcola#1
StarryOS bonus artifact: qcl-kernel/tgoskits-redcola#2
Bonus path: apps/starry/qemu/redcola-ai-control/
```

The guest program compares a fixed manual PWM baseline against a fixed-point
neural-network control policy over eight samples. The network is intentionally
tiny and deterministic for reproducibility: a 4-input, 4-hidden-unit ReLU MLP
computes a PWM command from demand, load, vibration, and bias features before
the simulated plant reports the tracking error. A successful run prints:

```text
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0
```

## Build and Run

From the repository root:

```sh
cargo xtask starry app qemu -t qemu/redcola-ai-control --arch aarch64
```

This case is a Rust Starry app case. Its `prebuild.sh` is intentionally small:
it only writes `rust/src/prebuild_marker.txt`, which `build.rs` embeds so the
guest log can prove that the prebuild hook ran. The actual Rust cross-build and
rootfs installation are handled by the normal Starry app runner invoked by
`cargo xtask starry app qemu`. That runner builds the static AArch64 musl
program from `rust/` and injects the generated overlay so the guest sees the
program as `/usr/bin/redcola-ai-control`.

The QEMU config then runs `/usr/bin/redcola-ai-control` as the shell init
command and treats the final DONE line as the success marker, after the full
PASS metrics line and `prebuild_marker=prebuild-ok` have already been printed.
For AArch64, the case selects `virt,gic-version=3` explicitly so the QEMU
machine exposes the interrupt-controller model expected by the current
StarryOS platform code.

## Environment Note

The StarryOS kernel build depends on the repository's normal AArch64 bare-metal
toolchain. On minimal Kali images without `aarch64-linux-musl-gcc`, the local
validation used a temporary clang-based freestanding wrapper outside the git
tree under `/tmp/redcola-toolchain/bin`, plus a tiny temporary sysroot under
`/tmp/redcola-freestanding-sysroot`. Those files are not part of this case.

Minimal Kali validation command after preparing that wrapper:

```sh
SYS=/tmp/redcola-freestanding-sysroot
RES=$(clang -print-resource-dir)
export PATH=/tmp/redcola-toolchain/bin:$PATH
export BINDGEN_EXTRA_CLANG_ARGS="-nostdinc -isystem $SYS/include -isystem $RES/include"
cargo xtask starry app qemu -t qemu/redcola-ai-control --arch aarch64
```

The wrapper must provide `aarch64-linux-musl-gcc -print-sysroot` and compile
freestanding AArch64 C sources with clang. A normal distro-provided
`aarch64-linux-musl-gcc` toolchain can be used instead.

Validation evidence should record the full QEMU log, its SHA-256 digest, the
full PASS metrics line, and the final DONE marker used by the QEMU runner. A
passing MLP run contains lines like:

```text
REDCOLA_STARRY_AI_BEGIN guest=StarryOS role=non_rt_guest model=fixed_point_mlp_policy hidden=4
REDCOLA_STARRY_CONTROL_SUMMARY manual_abs_error=1013 ai_abs_error=0 max_ai_error=0
REDCOLA_STARRY_QCZ1_PARITY_PASS setpoint_milli=930 ai_score_milli=1000 sample_id=1
REDCOLA_STARRY_AI_CONTROL_PASS samples=8 manual_abs_error=1013 ai_abs_error=0
REDCOLA_STARRY_AI_DONE
```

## Final Evidence Checklist

Before referencing this bonus PR in the final contest package, verify that the
recorded evidence includes:

- the branch name `contest/starry-redcola-ai-bonus-clean-20260731`;
- the path `apps/starry/qemu/redcola-ai-control/`;
- the QEMU command `cargo xtask starry app qemu -t qemu/redcola-ai-control --arch aarch64`;
- the AArch64 machine argument `virt,gic-version=3`;
- the `prebuild_marker=prebuild-ok` line;
- the `REDCOLA_STARRY_CONTROL_SUMMARY` line;
- the `REDCOLA_STARRY_QCZ1_FRAME` and `REDCOLA_STARRY_QCZ1_PARITY_PASS` lines;
- the `REDCOLA_STARRY_AI_CONTROL_PASS` line;
- the final `REDCOLA_STARRY_AI_DONE` line;
- the QEMU log SHA-256.

Do not include generated rootfs images, target directories or temporary
toolchain wrappers in this PR. They are runtime artifacts, not source
submission files.
