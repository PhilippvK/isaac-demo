# Query-time node filtering experiment

## Decision

Targeted query-time filtering is worthwhile for mixed blocks. Most of the measured
benefit is available from properties already exported by the LLVM CDFG pass;
adding annotations everywhere is not the first optimization to implement.
A backend-specific, versioned support flag is useful for capability checks that
cannot be expressed cheaply using those properties, but it is an incremental
improvement over a server-side candidate filter, not a cure for combinatorial
path enumeration. No production implementation was changed for this experiment.

## Method and scope

* Query repository: `3987f6fc6d93a6e155287943b8437cf1acf0417a`; `tool/queries.py` SHA256: `f689d0b0d7b03f9ba76843917b3f5cb952bae85be2e936611a129b290834dc02`.
* Snapshots: 2,423 SHA256 nodes / 3,645 DFG edges; 509 Genie CRC32 nodes / 469 edges;
  464 ISAAC CRC32 nodes / 435 edges. These are existing real stage-32 CDFGs.
* Shared-database experiments used read-only queries on 2026-10-30. Real boolean
  annotations were measured on 2026-11-02 in a separate temporary Memgraph clone
  with 3,396 copied nodes, 1 GiB container memory, two CPUs, and RAM-backed storage.
  The clone used the same locally installed Memgraph image and standard INSTR
  indexes exported by CDFGPass, plus an import-only source-ID index.
* Base queries came from the current generator, retaining its default ignored
  names/types, GPR|UNKNOWN register filtering, shared-output traversal and width 2.
  The main repeated experiment used lengths 1..9, max_nodes=1000, no row limit,
  and three randomized repetitions. Times are medians in milliseconds and include
  fetching the full path results and extracting node identities. Each query had
  a six-second transaction timeout.
* The CFU-local necessary-condition filter rejects internal nodes with mayLoad,
  mayStore, isBranch or isTerminator. The generic no-memory filter rejects only
  mayLoad/mayStore. This is not a full CFU operand/encoding legality check. In
  particular the base register mask is the generic GPR|UNKNOWN mask, not the
  stricter GPR-only mask in cfu.yml.
* A separate experimental code-generation support mask combines the no-memory
  rule with the implemented dispatch names in the current cdsl_utils visitor,
  excluding explicitly unimplemented DIV/REM/LUI. It is a capability prototype,
  not an independently verified universal operation whitelist.
* Variants: current query followed by Python filtering; a server ALL predicate
  after constructing all_nodes but before RETURN/LIMIT; predicates on the shared
  anchor and every DFS expansion; and corresponding precomputed boolean variants
  in the clone. Earlier read-only ID-mask trials were a prototype and were
  superseded by the actual boolean-annotation measurements.
* 495 uncapped query-variant comparisons retained exactly the same path-row
  multisets as applying the same predicate to the baseline results. This verifies
  these predicates, not equivalence of the entire final custom-instruction pipeline.
* Counts are returned path-combination rows, not deduplicated custom instructions.
  The current subgraph stage handles each such row. We counted the actual result
  records rather than using query_metrics.csv, whose current row accumulation
  sums successive cumulative subgraph counts and can overstate the row total.

## Main result: clone, CFU-local necessary filter

| Block | Candidate rows before → after | Query ms before → boolean DFS | I/O-analysis ms before → after |
| --- | --- | --- | --- |
| sha_load | 142 → 28 | 171.1 → 59.8 | 251.0 → 45.5 |
| sha_mixed | 164 → 25 | 167.3 → 56.0 | 269.8 → 41.1 |
| crc_alloc | 344 → 170 | 369.9 → 181.8 | 583.9 → 284.1 |
| sha_hot_miso0 | 348 → 348 | 373.2 → 375.2 | 593.8 → 593.9 |

The I/O timings call the existing, unmodified `analyze_io` stage on the actual
candidate rows, using fresh copies of the saved function graph, three times.
They exclude dataframe initialization and graph-copy setup. They do not include
isomorphism, variation generation, encoding checks, or code generation. Thus these
are measured query and I/O-stage improvements, not full-flow speedup claims.

## Does a new annotation add much beyond existing properties?

| Block | Base rows | Kept rows | Baseline query ms | Server ALL ms | Inline DFS ms | Boolean ALL ms | Boolean DFS ms |
| --- | --- | --- | --- | --- | --- | --- | --- |
| crc_alloc | 344 | 170 | 369.9 | 188.6 | 183.3 | 189.4 | 181.8 |
| crc_arith | 4 | 4 | 33.2 | 33.8 | 43.3 | 33.8 | 34.5 |
| crc_isaac_hot | 42 | 11 | 66.4 | 42.3 | 47.5 | 41.5 | 39.8 |
| crc_rand | 105 | 53 | 129.4 | 82.2 | 86.7 | 79.4 | 79.6 |
| sha_hot_miso0 | 348 | 348 | 373.2 | 380.6 | 387.6 | 383.2 | 375.2 |
| sha_load | 142 | 28 | 171.1 | 70.7 | 67.0 | 65.4 | 59.8 |
| sha_mixed | 164 | 25 | 167.3 | 63.0 | 65.0 | 61.8 | 56.0 |

The server-side ALL filter on existing properties already gives most of the
reduction. Direct inline checking at each DFS expansion can cost more than the
later server filter on small graphs. A boolean avoids repeated multi-property
or opcode-list evaluation and is typically slightly faster, but the incremental
benefit over the server filter is generally only a few milliseconds here.
On the arithmetic-only SHA partition it prunes no rows and provides no gain.

There is some additional scope for backend capability metadata: on CRC malloc,
the no-memory filter alone retained 240 rows, whereas the experimental
no-memory + code-generation support mask retained 170 (29% fewer). This block
contains BLTU, which is not handled by the current CDSL operation dispatcher,
unlike BNE/BEQ. Under CFU-local restrictions that branch is already rejected,
so the opcode-support mask adds no further reduction on these CFU test cases.

## Limits and hard cases

Unpartitioned SHA blocks with 931 and 309 base-eligible internal nodes timed out
in all four pilot variants at six seconds, even with max path length three.
The additional node predicates did not solve that hard case. The existing MISO
partitioning, path bounds and server timeouts remain essential. Tests on existing
MISO partitions completed and showed much less to prune in arithmetic regions.

A deliberately small LIMIT 20 demonstrated sample starvation: SHA load block
%bb.1 returned 20 baseline rows but none passed the CFU-local filter. Filtering
before LIMIT returned 20 eligible rows. SHA digest returned 7 eligible rows after
postfiltering versus 20 with query filtering. This is useful, but it changes the
bounded traversal-order sample; capped outputs are not expected to be identical,
and neither query is a global largest-first search.

## Recommendation before implementation

1. Push sound node-local exclusions into the generated query from the active
   settings, starting with zero memory/branch/terminator allowances and forbidden
   instruction-predicate bits. Use the existing CDFG properties first.
2. Compare server-final predicates versus DFS predicates for the active query
   shape; do not assume the earliest possible check is always the fastest.
3. If backend checks are expensive or more precise than existing flags, add a
   target/backend/version-specific support annotation, including the rejection
   reason and configuration provenance. Derive it from the same capability logic
   used by code generation, rather than maintaining an unrelated opcode list.
   Check annotation coverage/version before using it to discard candidates.
4. Retain final validation. Input/output counts can shrink when additional nodes
   are incorporated into a candidate; encoding, immediate reuse and I/O limits
   depend on the complete candidate. They cannot safely become blanket per-node
   rejection flags. Positive memory caps can use monotone counts on path unions,
   but rejecting every load when one load is permitted would be incorrect.
5. Treat predicate filtering as one optimization. It will not accelerate purely
   supported arithmetic regions or replace partitioning for explosive queries.

## Reproduction and artifacts

All scripts, generated Cypher, snapshots and measurements are in this directory:

* `inventory.py`, `fetch_isaac_crc.py`: read-only graph snapshots.
* `bench.py`: current query generator with scratch-only query transformations;
  `--uri`, `--high`, `--cases`, `--profiles`, `--modes`, `--repeats`, `--limit`.
* `load_clone.py`: refuses a nonempty destination and populates only port 28763.
* `io_bench.py`: extracts init_subs_df through the AST without importing the
  executable tool.main module, then runs the existing analyze_io function.
* `pilot`, `partition-pilot`, `repeated-L9`, `clone-annotations-L9`,
  `capped-sampling`: JSON and CSV raw results; `io-stage.json`: stage timings.
* `source_versions.json`: source revision and query content hash.

Example reproduction on an already seeded isolated clone:

```sh
venv/bin/python /tmp/isaac-query-pushdown-20261030/bench.py \
  --uri bolt://127.0.0.1:28763 --high 9 --repeats 3 \
  --cases sha_load sha_mixed crc_alloc crc_rand crc_isaac_hot crc_arith sha_hot_miso0 \
  --profiles no_mem no_mem_codegen cfu_local \
  --modes late early annotated_late annotated_early --output reproduced
```

The temporary container is removed after the experiment. No shared-database
annotations or project source changes were made. The graph snapshots and scratch
scripts allow the clone to be recreated if another run is needed.
