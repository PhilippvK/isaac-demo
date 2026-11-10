# Investigation reports

These reports and selected evidence are stored in the repository so cleaning
`/tmp` does not remove them. They record the implementation at investigation time;
later fixes do not invalidate the historical findings.

- [LLVM 22 migration complexity assessment](llvm22-migration/report.md)
- [Dynamic BB matching utilization comparison](bb-utilization-20261103/report.md)
- [Compiler retargeting repair](compiler-retargeting-20261103/report.md)
- [BB mapping quality and regression experiment](bb-quality-20261102/report.md)
- [Basic block identities and ELF decoding](bb-identities/report.md)
- [Export parallelism](export-parallelism/report.md)
- [Query-level filtering](query-filtering/report.md)

Each directory includes the report, commands, source/version metadata, numerical
results, and available reproducer scripts/fixtures. Compiler logs are compressed
under `logs/`. Generated binaries and bulk graph/image exports are excluded.
Historical scripts retain their original absolute paths; adjust their output
locations before rerunning them. Use repository copies of evidence when an old
report mentions its original `/tmp` location.

The subsequent implementation and migration notes are in
[Decoder and BB mapping fixes](bb-identities/fixes.md).

## Compiler, HLS and physical FPGA experiments

- [LLVM 22 implementation](llvm22-port/report.md)
- [LLVM version comparison](llvm-version-ise-20261104/report.md)
- [Fused conditional branches](fused-branches-20261104/report.md)
- [Fused scalar memory](fused-memory-20261104/report.md)
- [CVA5 HLS and SCAIE-V handoff](cva5-reuseio-hls-20261105/report.md)
- [Arty implementation](cva5-arty-a7-100-20261105/build-results.md)
- [Physical FPGA firmware execution](cva5-fpga-execution-20261105/report.md)
- [Commits, portable backups and upstreaming](upstreaming-20261107/README.md)

The committed evidence includes the three validated FPGA bitstreams and firmware
snapshots. Bulk compiler installs, routed checkpoints, large instruction traces,
and disposable dependency checkouts remain local and are not part of Git.
`upstreaming-20261107/preserved-artifacts.json` lists the selected evidence and hashes.
Generated HLS RTL is retained as `cva5-reuseio-hls-20261105/selected-generated-rtl.tar.gz`;
restore its original repository-relative paths with:

```sh
tar -xzf reports/cva5-reuseio-hls-20261105/selected-generated-rtl.tar.gz
```

Historical HLS/FPGA reports used the working `cva5_reuseio` configuration at the
time of the experiment. Current opt-in equivalents are
`cva5_reuseio_mem_branch` and `cva5_reuseio_mem_branch_arty_a7_100t`.
The current original preset disables memory/branch effects and uses a generic
FPGA target. Board-only selection is `cva5_reuseio_arty_a7_100t`.

- [VEX_5S without reuse-I/O: HLS and RTL execution](vex-5s-hls-20261107/report.md).

- [Integrated CVA5/Vex RTL benchmark execution](rtl-sim-integration-20261109/report.md).

- [Native MLonMCU RTL target and scoped GISel workaround](mlonmcu-rtl-integration-20261109/report.md).
