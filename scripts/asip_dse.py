import os
import argparse
import tempfile
import subprocess
from concurrent.futures import ThreadPoolExecutor, TimeoutError

# import csv
from queue import Queue
from math import ceil
from pathlib import Path
import pandas as pd

DIR = os.path.dirname(os.path.realpath(__file__))

TIMEOUT = 60 * 10
NUM_LICENSES = 16

OLD_STEP_MULT = 1.5
# OLD_STEP_MULT = 1.0


def run_asip_flow(clock_speed, core, pdk, rtl_src):
    """Invokes the ASIP design flow and returns the chip area or None if the frequency is too high."""
    # args = ["./fake_metrics.sh", str(clock_speed)]  # Adjust command as needed
    with tempfile.TemporaryDirectory() as tmpdirname:
        out_file = Path(tmpdirname) / "report.csv"
        clock_period = 1000.0 / clock_speed

        args = [
            f"{DIR}/asip_syn_script.sh",
            str(out_file),
            str(rtl_src),
            core,
            pdk,
            str(clock_period),
        ]  # Adjust command as needed
        print(">", " ".join(args))
        # print("cwd", tmpdirname)
        # input(">>>")
        # result = subprocess.run(
        try:
            with open(Path(tmpdirname) / "out.log", "wb") as stdout, open(Path(tmpdirname) / "err.log", "wb") as stderr:
                _ = subprocess.run(
                    args,
                    # capture_output=True,
                    # text=True,
                    check=True,
                    stdout=stdout,
                    stderr=stderr,
                    cwd=tmpdirname,
                )
        except subprocess.CalledProcessError as e:
            # print("ERR", tmpdirname)
            # input("!!!")
            # TODO: detect license limit
            with open(Path(tmpdirname) / "out.log", "r") as f:
                content = f.read()
            # print("tmpdirname", tmpdirname)
            # print("content", content)
            if "Error: All 'Design-Compiler' licenses are in use. (SEC-50)" in content:
                return None, None, None, "LIMIT"
            print("content", content)
            with open(Path(tmpdirname) / "err.log", "r") as f:
                content2 = f.read()
            print("content2", content2)
            input("!")
            # raise e
            return None, None, None, "ERROR"
        # output = result.stdout.strip()
        # chip_area = float(output)  # Assuming the script returns the chip area as a float
        df = pd.read_csv(out_file)
        print("df", df)
        assert len(df) == 1
        total_cell_area = df["total_cell_area"].iloc[0]
        isax_area = df["isax_area"].iloc[0]
        isax_area_rel = df["isax_area_rel"].iloc[0]
        status = df["status"].iloc[0]
        # if status != "MET":
        #     return None, None
        # slack = df["slack"]
    return total_cell_area, isax_area, isax_area_rel, status


def evaluate_frequency(freq, core, pdk, rtl_src):
    """Runs the ASIP flow for a single frequency and logs the result."""
    total_area, isax_area, isax_area_rel, status = run_asip_flow(freq, core, pdk, rtl_src)
    return total_area, isax_area, isax_area_rel, status


def hierarchical_search(min_freq, max_freq, resolution, max_threads, log_data, core, pdk, rtl_src):
    """Performs a hierarchical search using multiple threads and logs results."""
    width = max_freq - min_freq
    num_threads = min(ceil(width / resolution), max_threads)
    step = ceil(width / max(num_threads - 1, 1))
    min_freq_ = min_freq
    max_freq_ = max_freq
    queue = Queue()
    best_freq = None
    known_freqs = set()

    while (step * max_threads) >= resolution:
        with ThreadPoolExecutor(max_threads) as executor:
            freqs = []
            for i in range(max_threads):
                test_freq = min_freq_ + i * step
                test_freq = min(test_freq, max_freq)
                if test_freq in known_freqs:
                    continue
                known_freqs.add(test_freq)
                freqs.append(test_freq)
            print("freqs", freqs)

            max_tries = 4
            tries = 0
            while len(freqs) > 0 and tries <= max_tries:
                futures = {}
                tries += 1
                print("tries", tries)
                for test_freq in freqs:
                    future = executor.submit(evaluate_frequency, *(test_freq, core, pdk, rtl_src))
                    futures[test_freq] = future
                freqs = []

                for freq, future in futures.items():
                    print("freq", freq)
                    try:
                        result = future.result(timeout=TIMEOUT)
                        print("result", result)
                        total_area, isax_area, isax_area_rel, status = result
                        log_data.append((freq, total_area, isax_area, isax_area_rel, status))
                        print("status", status)
                        if status == "LIMIT":
                            freqs.append(freq)
                        elif status == "ERROR":
                            pass
                            # freqs.append(freq)
                        elif status == "MET":
                            queue.put(freq)  # Store valid frequency
                    except TimeoutError:
                        log_data.append((freq, None, None, None, "TIMEOUT"))
                        continue
                    if future.exception():
                        print("exep")
                        freqs.append(freq)
                    # else:
                    #     assert False, "not handled"
                if len(freqs) > 0:
                    print(f"RETRY {len(freqs)} runs: {freqs}")

        # Find the highest valid frequency from this level
        best_freqs = [queue.get() for _ in range(queue.qsize())]
        if not best_freqs:
            break  # No valid frequency found, exit
        print("---")
        best_freq = max(best_freqs)

        min_freq_ = best_freq  # Continue searching in the highest valid region
        # new_step = step
        new_step = step * OLD_STEP_MULT
        max_freq_ = min_freq_ + new_step  # Narrow down the range
        min_freq_ = (min_freq_ // resolution) * resolution
        min_freq_ += resolution
        max_freq_ -= resolution
        max_freq_ = min(max_freq_, max_freq)
        width = max_freq_ - min_freq_
        num_threads = min(ceil(width / resolution), max_threads)
        step = ceil(width / max(num_threads - 1, 1))  # Reduce step size
        # print("step", step, step * num_threads)
        # step = ceil((max_freq - min_freq) / (num_threads))  # Reduce step size

    return best_freq * resolution // resolution if best_freq is not None else None


def write_csv(file_path, log_data):
    """Writes log data to a CSV file."""
    # with open(file_path, mode="w", newline="") as file:
    #     writer = csv.writer(file)
    #     writer.writerow(["Clock Frequency (MHz)", "Total Area", "ISAX Area", "ISAX Area (rel.)", "Status"])
    #     writer.writerows(log_data)
    df = pd.DataFrame(
        log_data, columns=["Clock Frequency (MHz)", "Total Area", "ISAX Area", "ISAX Area (rel.)", "Status"]
    )
    df = df.sort_values("Clock Frequency (MHz)")
    df.to_csv(file_path, index=False)


def main():
    parser = argparse.ArgumentParser(description="ASIP Design Space Exploration")
    parser.add_argument("rtl_src", help="RTL directory")
    parser.add_argument("--threads", type=int, default=4, help="Number of parallel threads")
    parser.add_argument("--min-freq", type=int, default=100, help="Minimum clock frequency in MHz")
    parser.add_argument("--max-freq", type=int, default=400, help="Maximum clock frequency in MHz")
    parser.add_argument("--resolution", type=int, default=5, help="Resolution for stopping the search in MHz")
    parser.add_argument("--csv", type=str, default=None, help="Path to CSV file for logging results")
    parser.add_argument("--core", type=str, default="VEX_5S", help="RTL core")
    parser.add_argument("--pdk", type=str, default="NangateOpenCellLibrary", help="PDK techlib")
    args = parser.parse_args()

    if args.threads > NUM_LICENSES:
        print(f"WARNING: using more threads ({args.threads}) than available licenses ({NUM_LICENSES})!")

    log_data = []
    max_feasible_clock = hierarchical_search(
        args.min_freq, args.max_freq, args.resolution, args.threads, log_data, args.core, args.pdk, args.rtl_src
    )

    print(f"Maximum feasible clock speed: {max_feasible_clock} MHz")

    if args.csv:
        write_csv(args.csv, log_data)
        print(f"Results saved to {args.csv}")


if __name__ == "__main__":
    main()
