typedef unsigned long usize;

enum {
    SYS_WRITE = 64,
    SYS_EXIT = 93,
    SYS_SCHED_SETAFFINITY = 122,
    SYS_EXECVE = 221,
};

static long syscall6(
    long number,
    long arg0,
    long arg1,
    long arg2,
    long arg3,
    long arg4,
    long arg5
) {
    register long x0 asm("x0") = arg0;
    register long x1 asm("x1") = arg1;
    register long x2 asm("x2") = arg2;
    register long x3 asm("x3") = arg3;
    register long x4 asm("x4") = arg4;
    register long x5 asm("x5") = arg5;
    register long x8 asm("x8") = number;

    asm volatile(
        "svc #0"
        : "+r"(x0)
        : "r"(x1), "r"(x2), "r"(x3), "r"(x4), "r"(x5), "r"(x8)
        : "memory"
    );
    return x0;
}

static usize string_length(const char *text) {
    usize length = 0;

    while (text[length] != '\0') {
        length++;
    }
    return length;
}

static void write_text(const char *text) {
    syscall6(SYS_WRITE, 1, (long)text, (long)string_length(text), 0, 0, 0);
}

__attribute__((noreturn)) static void exit_process(long status) {
    syscall6(SYS_EXIT, status, 0, 0, 0, 0, 0);
    for (;;) {
    }
}

static int parse_cpu(const char *text, usize *cpu) {
    usize value = 0;
    usize index = 0;

    if (text[0] == '\0') {
        return 0;
    }
    while (text[index] != '\0') {
        char digit = text[index++];

        if (digit < '0' || digit > '9') {
            return 0;
        }
        value = value * 10 + (usize)(digit - '0');
        if (value >= sizeof(usize) * 8) {
            return 0;
        }
    }
    *cpu = value;
    return 1;
}

__attribute__((noreturn, noinline, used)) static void qc_main(usize *stack) {
    usize argc = stack[0];
    char **argv = (char **)&stack[1];
    char **envp;
    usize cpu = 0;
    usize mask;
    long status;

    if (argc < 3 || !parse_cpu(argv[1], &cpu)) {
        write_text("QC_AFFINITY_RESULT=FAIL_ARGUMENT\n");
        exit_process(2);
    }

    mask = 1UL << cpu;
    status = syscall6(
        SYS_SCHED_SETAFFINITY,
        0,
        (long)sizeof(mask),
        (long)&mask,
        0,
        0,
        0
    );
    if (status < 0) {
        write_text("QC_AFFINITY_RESULT=FAIL_SET\n");
        exit_process(3);
    }

    write_text("QC_AFFINITY_RESULT=PASS\n");
    envp = &argv[argc + 1];
    status = syscall6(SYS_EXECVE, (long)argv[2], (long)&argv[2], (long)envp, 0, 0, 0);
    (void)status;
    write_text("QC_AFFINITY_RESULT=FAIL_EXEC\n");
    exit_process(4);
}

__attribute__((naked, noreturn)) void _start(void) {
    asm volatile(
        "mov x0, sp\n"
        "b qc_main\n"
    );
}
