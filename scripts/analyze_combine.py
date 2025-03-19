# TODO
import subprocess
from pathlib import Path
from typing import Optional, Union, List

import yaml


def combine_helper(
    out_file: Union[str, Path],
    files: List[Union[str, Path]],
    sort_by: Optional[str] = None,
    topk: Optional[int] = None,
    venn: bool = False,
    sankey: bool = False,
    overlaps: bool = False,
):
    out_file = Path(out_file)
    extra_args = [
        "--drop",
        *(["--sort-by", sort_by] if sort_by is not None else []),
        *(["--topk", str(topk)] if topk is not None else []),
    ]
    if venn:
        venn_file = out_file.parent / (f"{out_file.stem}.jpg")
        extra_args += ["--venn", venn_file]
    if sankey:
        sankey_file = out_file.parent / (f"{out_file.stem}.md")
        extra_args += ["--sankey", sankey_file]
    if overlaps:
        overlaps_file = out_file.parent / (f"{out_file.stem}.csv")
        extra_args += ["--overlaps", overlaps_file]
    args = ["python3", "-m", "tool.combine_index", "--out", out_file, *extra_args, *files]
    subprocess.run(args, check=True)


def generate_helper(
    index_file: Union[str, Path],
    out_dir: Union[str, Path],
    cdsl: bool = True,
    flat: bool = True,
    fuse_cdsl: bool = True,
):
    out_dir = Path(out_dir)
    out_dir.mkdir(exist_ok=True)
    generate_args = [
        index_file,
        "--output",
        out_dir,
        "--split",
        "--split-files",
        "--progress",
        "--inplace",  # TODO use gen/index.yml instead!
    ]
    if cdsl:
        generate_cdsl_args = [
            "python3",
            "-m",
            "tool.gen.cdsl",
            *generate_args,
        ]
        subprocess.run(generate_cdsl_args, check=True)
    if flat:
        generate_flat_args = [
            "python3",
            "-m",
            "tool.gen.flat",
            *generate_args,
        ]
        subprocess.run(generate_flat_args, check=True)
    if fuse_cdsl:
        generate_fuse_cdsl_args = [
            "python3",
            "-m",
            "tool.gen.fuse_cdsl",
            *generate_args,
        ]
        subprocess.run(generate_fuse_cdsl_args, check=True)


FILES = [
    "out/cmsis_nn/arm_nn_activation_s16_tanh/20250225T104337/work/combined_index.yml",
    "out/cmsis_nn/arm_nn_activation_s16_sigmoid/20250225T130008/work/combined_index.yml",
    "out/rnnoise_INT8/20250303T105132/work/combined_index.yml",
    "out/coremark/20250130T094350/work/combined_index.yml",
    "out/dhrystone/20250130T131241/work/combined_index.yml",
    "out/embench/crc32/20250317T083622/work/combined_index.yml",
    "out/embench/nettle-aes/20250303T214552/work/combined_index.yml",
    "out/taclebench/kernel/md5sum/20250130T135750/work/combined_index.yml",
]

OUT = "/tmp/combine_all/index.yml"
GEN_DIR = "/tmp/combine_all/gen/"

combine_helper(OUT, FILES, venn=len(FILES) in [2, 3], sankey=True, overlaps=True)

with open(OUT, "r") as f:
    combined_index_data = yaml.safe_load(f)

# print("combined_index_data", combined_index_data)

dot_files = [
    (
        candidate_data["id"],
        candidate_data["properties"],
        Path(candidate_data["artifacts"]["io_sub"].replace(".pkl", ".dot")),
    )
    for candidate_data in combined_index_data["candidates"]
]

for i, temp in enumerate(dot_files):
    id_, properties, file = temp
    # print("props", properties)
    print(f"{i} [{id_}]\t: {file}")

print("Generating...")

generate_helper(OUT, GEN_DIR, cdsl=True, flat=True, fuse_cdsl=True)
