import argparse
import subprocess
from typing import Union
from pathlib import Path

import yaml


def dot2pdf_helper(in_file: Union[str, Path], out_file: Union[str, Path]):
    with open(out_file, "wb") as f:
        dot_args = ["dot", "-Tpdf", in_file]
        print(">", " ".join(map(str, dot_args)))
        _ = subprocess.run(dot_args, check=True, stdout=f)
    print(f"Converted {in_file} -> {out_file}")


def main():
    parser = argparse.ArgumentParser(description="Extract dot files from index and merge graphs into single pdf")
    parser.add_argument("index", help="Index yaml file")
    parser.add_argument("-o", "--output", required=True, help="Output CSV file")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)

    pdf_files = [
        Path(candidate_data["artifacts"]["io_sub"].replace(".pkl", ".pdf"))
        for candidate_data in combined_index_data["candidates"]
    ]
    dot_files = [
        Path(candidate_data["artifacts"]["io_sub"].replace(".pkl", ".dot"))
        for candidate_data in combined_index_data["candidates"]
    ]
    for i, pdf_file in enumerate(pdf_files):
        print(i, pdf_file)
        if not pdf_file.is_file():
            print("if")
            dot_file = dot_files[i]
            assert dot_file.is_file()
            dot2pdf_helper(dot_file, pdf_file)
    assert len(pdf_files) > 0, "No files found!"
    assert args.output is not None
    out_file = Path(args.output)
    combine_args = ["pdfunite", *pdf_files, out_file]
    print(">", " ".join(map(str, combine_args)))
    _ = subprocess.run(combine_args, capture_output=True, text=True, check=True)
    print(f"Wrote combined PDF file: {out_file}")


if __name__ == "__main__":
    main()
