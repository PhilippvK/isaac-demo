# Tuesday session recovery

Recovered on 2026-11-12 from the intact local transcript.

Session: `01a17d95-ddf4-7aa0-bc99-3f891e024cb8`
Workspace: `/var/tmp/ga87puy/isaac-demo-new`
Transcript: `/nas/ei/share/TUEIEDAscratch/ga87puy/work/.codex/sessions/2026/10/27/rollout-2026-10-27T14-38-56-01a17d95-ddf4-7aa0-bc99-3f891e024cb8.jsonl`

## Last requested work

Following the completed Arty integration, the user accepted these next steps:
investigate the CRC32 result, improve and measure one candidate, run branch/store
ISE probes on FPGA, and generalize FPGA execution through MLonMCU.

## Completed before interruption

- Original integration and hardware evidence committed as `9968b0c` and `a7dc820`.
- Transcript reports FPGA branch probes passing 1,344 checks and custom store
  probes passing 48 checks, with native store checks also passing. Captures and
  execution metadata survive in `board-branches/` and `board-stores/`.
- Transcript reports CRC32 memory ISE removes three instructions but adds three
  stall cycles: one exposed multiply dependency and two around injected memory.
- Transcript reports arithmetic index ISE plus native load passes five RTL pairs:
  14,361 versus 16,408 cycles (about 12.5% fewer cycles).
- Added explicit `nailgun.execution=fpga` integration; edits remain uncommitted.

## Jobs that finished after the last progress update

These findings were checked directly against saved logs during recovery:

- `crc-index-vivado.log`: bitstream generation completed at 11:25:36 local time
  on Tuesday, with zero critical warnings and zero errors.
- `mlonmcu-fpga-crc32.log`: session 15 completed successfully, validation True;
  reported benchmark Run Cycles 5,573,423. This is a separate benchmark run,
  not the paired intrinsic experiment above.
- `mlonmcu-fpga-sine.log`: session 17 completed successfully, validation True,
  numerical validation 4/4, Run Cycles 57,909.

## Remaining work

1. Inspect surviving arithmetic-index bitstream and firmware, then run its
   paired physical-board measurement. No corresponding board capture was found
   in this follow-up report directory during recovery.
2. Review uncommitted FPGA runner, firmware, flow, RTL helper, and MLonMCU edits;
   inspect required checks before finalizing.
3. Preserve final measurements and source versions in a follow-up report.
4. Commit reviewed implementation and evidence as appropriate.

Recovery did not program hardware, resume background jobs, modify existing
source edits, or change the session database. The app thread-list API failed
with a state-database internal error; the transcript was recovered directly.

## Continuation completed on November 12

The hardware index measurement passed (14,361 vs 16,408 cycles in all five
pairs). The helper run passed and its FPGA artifacts were exported and checked.
See `report.md`, `results.json`, and `manifest.json` for final evidence.
