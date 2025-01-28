from typing import Dict, Optional

import matplotlib.pyplot as plt
import pandas as pd


def enc_helper(enc_size, used_space):
    enc_space = 2**32

    major_bits = 7
    minor_bits = 3
    func7_bits = 7
    func2_bits = 2

    major_count = 4  # custom-0, custom-1, custom-2, custom-3
    minor_count = 2**minor_bits
    func2_count = 2**func2_bits
    func7_count = 2**func7_bits

    major_space = 2 ** (enc_size - major_bits)
    minor_space = 2 ** (enc_size - major_bits - minor_bits)
    func2_space = 2 ** (enc_size - major_bits - minor_bits - func2_bits)
    func7_space = 2 ** (enc_size - major_bits - minor_bits - func7_bits)

    major_space_total = major_count * major_space
    minor_space_total = major_count * minor_count * minor_space
    func2_space_total = major_count * minor_count * func2_count * func2_space
    func7_space_total = major_count * minor_count * func7_count * func7_space

    return (
        enc_space,
        used_space,
        major_space,
        minor_space,
        func2_space,
        func7_space,
        major_space_total,
        minor_space_total,
        func2_space_total,
        func7_space_total,
    )


def enc_helper2(properties, enc_size, major_count: int = 4):
    enc_bits_used = properties["OperandEncBitsSum"]
    enc_bits_left = properties[f"EncodingBitsLeft ({enc_size} bits)"]
    enc_footprint = properties[f"EncodingFootprint ({enc_size} bits)"]
    enc_weight = properties[f"EncodingWeight ({enc_size} bits)"]
    assert enc_footprint < 1.0

    # divide weight by 4 as there are 4 major opcodes (custom-0, custom-1, custom-2, custom-3)
    assert major_count in [1, 2, 3, 4]
    enc_weight_ = enc_weight / major_count
    return enc_bits_used, enc_bits_left, enc_footprint, enc_weight_


def enc_helper3(
    used_space,
    major_space,
    major_space_total,
    minor_space,
    minor_space_total,
    func2_space,
    func2_space_total,
    func7_space,
    func7_space_total,
):
    enc_footprint_major = used_space / major_space
    enc_footprint_major_total = used_space / major_space_total

    enc_footprint_minor = used_space / minor_space
    enc_footprint_minor_total = used_space / minor_space_total

    enc_footprint_func2 = used_space / func2_space
    enc_footprint_func2_total = used_space / func2_space_total

    enc_footprint_func7 = used_space / func7_space
    enc_footprint_func7_total = used_space / func7_space_total

    return (
        enc_footprint_major,
        enc_footprint_major_total,
        enc_footprint_minor,
        enc_footprint_minor_total,
        enc_footprint_func2,
        enc_footprint_func2_total,
        enc_footprint_func7,
        enc_footprint_func7_total,
    )


def collect_weights(index_data: dict, enc_size: int = 32):
    total_weight = 0
    weight_per_instr = {}
    bits_per_instr = {}
    footprint_per_instr = {}

    for i, candidate_data in enumerate(index_data["candidates"]):
        instr_name = f"CUSTOM{i}"
        properties = candidate_data["properties"]

        # used_space = int(2**enc_bits_used)
        # (enc_space, used_space, major_space, minor_space, func2_space, func7_space, major_space_total,
        #     minor_space_total, func2_space_total, func7_space_total) = enc_helper(enc_size)
        # enc_bits_used, enc_bits_left, enc_footprint, enc_weight
        used_bits, _, enc_footprint, enc_weight = enc_helper2(properties, enc_size)
        weight_per_instr[instr_name] = enc_weight
        bits_per_instr[instr_name] = used_bits
        footprint_per_instr[instr_name] = enc_footprint
        total_weight += enc_weight

    rest_weight = 1 - total_weight
    return total_weight, weight_per_instr, footprint_per_instr, rest_weight, bits_per_instr


def plot_enc_pie(
    ax,
    weight_per_instr: Dict[str, float],
    rest_weight: Optional[float] = None,
    combine: bool = False,
    legend: bool = True,
    title: Optional[str] = None,
):
    if combine:
        custom = sum(weight_per_instr.values())
        temp = {"used": custom}
    else:
        temp = {**weight_per_instr}

    if rest_weight is not None:
        temp["free"] = rest_weight

    pie = ax.pie(
        temp.values(),
        labels=list(temp.keys()) if not legend else None,
        autopct="%1.5f%%",
        # legend=legend,
        labeldistance=1 if not legend else None,
    )
    if legend:
        # Matplotlibs hides legend labels starting with an '_'...
        labels = list(temp.keys())
        ax.legend(labels, loc="center left", bbox_to_anchor=(1.0, 0.5))

    if title is not None:
        ax.set_title(title)

        return pie


def plot_enc_pie_multi(weight_per_instr: Dict[str, float], rest_weight: float):

    fig, axs = plt.subplots(1, 2, figsize=(12, 5))

    _ = plot_enc_pie(axs[0], weight_per_instr, rest_weight=rest_weight, combine=True, title="Footprint (Total)")
    _ = plot_enc_pie(axs[1], weight_per_instr, title="Footprint (Custom Only)")

    return fig


def get_enc_weights_df(total_weight, weight_per_instr, bits_per_instr, footprint_per_instr):
    enc_weights_data = [
        {
            "instr": instr,
            "bits": bits_per_instr.get(instr),
            "footprint": footprint_per_instr.get(instr),
            "weight": weight,
        }
        for instr, weight in weight_per_instr.items()
    ] + [{"instr": "*", "weight": total_weight}]
    enc_weights_df = pd.DataFrame(enc_weights_data)
    return enc_weights_df


def get_enc_score_df(enc_weights_df):
    score_df = enc_weights_df.copy().dropna()
    score_df["enc_score"] = score_df.loc[:, ["footprint", "weight"]].apply(
        lambda x: -1 if x["footprint"] > 1.0 else (1.0 - x["weight"]), axis=1
    )
    return score_df
