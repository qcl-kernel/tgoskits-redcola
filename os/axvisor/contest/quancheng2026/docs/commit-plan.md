# Final Commit Plan

This note records the final redcola commit boundary prepared on 2026-08-21
against official `dev` `0340ed6bfa36cedd543d48f515e751ccc5a379bf`.

No commit or push is performed until the team authorizes the final private
repository update.

## Commit 1: AxVM PCI Interrupt Routing

Suggested subject:

```text
fix(axvm): parse PCI interrupt-map passthrough IRQs
```

Exact scope:

```text
virtualization/axvm/src/boot/fdt/core/mod.rs
virtualization/axvm/src/boot/fdt/core/parser.rs
```

Purpose:

- parse PCI host-bridge `interrupt-map` parent IRQ sources;
- retain path-based passthrough entries until interrupt parsing completes;
- make the Zephyr e1000 INTx route available to the latest dual-guest runtime.

Validation:

```text
cargo fmt -p axvm -- --check: PASS
cargo check -p axvm: PASS
cargo test -p axvm --features host-test pci_interrupt_map_parent_sources_are_added_to_passthrough_routes -- --nocapture: 1/1 PASS
cargo test -p axvm --features host-test --lib: 296/296 PASS
latest-dev0340 Linux/Zephyr dual-guest QEMU: PASS
```

Merged PR `rcore-os/tgoskits#1770` is already present in the official base as
commit `024ecca10a4240a84b2c24bed2dc2361a6043d3e`; it is not duplicated here.

## Commit 2: Contest Delivery

Suggested subject:

```text
contest: finalize redcola latest-dev validation
```

Exact scope:

```text
os/axvisor/contest/quancheng2026/
```

It includes source, configuration, reproducibility documentation, compact
result summaries, final-package tooling and reviewer entry points. Generated
images, raw logs, pcaps, build caches, credentials and temporary experiment
directories remain outside git.

Primary final gates:

```text
official dev base: 0340ed6bfa36cedd543d48f515e751ccc5a379bf
dual guest: UDP 20/20, QCZ1 10/10, AI 10/10, result=PASS
task one: 30000 samples at 1 ms with two pinned stress workers, result=PASS
StarryOS latest-dev QEMU bonus: REDCOLA_STARRY_LATESTDEV0340_QEMU=PASS
final package dry run: FINAL_PACKAGE_BUILD=PASS, FINAL_PACKAGE_VERIFY=PASS
```

## Final Inspection

Before committing:

```bash
git diff --check
git status --short
git diff --name-only -- virtualization/axvm/src/boot/fdt/core/mod.rs virtualization/axvm/src/boot/fdt/core/parser.rs
git diff --name-only -- os/axvisor/contest/quancheng2026/
```

After creating the two commits, verify that every PR-relative path belongs to
one of the two scopes above and rerun the final package builder from the exact
committed head. The StarryOS bonus stays in private PR `#2` unless separately
authorized for an update.
