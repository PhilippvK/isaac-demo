"""Define inactive CVA5 signals without assigning any active datapath bits."""
import argparse
from pathlib import Path


def adapt(name, text):
    if name == 'writeback.sv':
        # Arrays use NUM_WB_UNITS as their common width, but only NUM_UNITS[i]
        # entries are populated. The full unit_done[i] participates in valid.
        marker = '    //Writeback\n'
        addition = '''    // Inactive writeback slots must not introduce X into valid/selection.
    generate for (genvar g = 0; g < CONFIG.NUM_WB_GROUPS; g++) begin: isaac_wb_defaults
        for (genvar u = NUM_UNITS[g]; u < NUM_WB_UNITS; u++) begin: padding
            assign unit_instruction_id[g][u] = '0;
            assign unit_done[g][u] = 1'b0;
            assign unit_rd[g][u] = '0;
        end
        for (genvar b = (NUM_UNITS[g] == 1 ? 1 : $clog2(NUM_UNITS[g]));
             b < $clog2(NUM_WB_UNITS); b++) begin: select_padding
            assign unit_sel[g][b] = 1'b0;
        end
    end endgenerate
'''
        # Declarations precede generated assignments for both conversion frontends.
        marker = '    typedef int unsigned unit_count_t [CONFIG.NUM_WB_GROUPS];'
        if text.count(marker) != 1:
            raise ValueError('Unexpected CVA5 writeback layout')
        text = text.replace(marker, marker+'\n'+addition)
    elif name == 'cva5.sv':
        addition = '''
    // The L1 arbiter also serves the MMUs when caches are disabled.
    // Terminate request fields for the absent caches, leaving MMU ports active.
    generate for (genvar i = 0; i < L1_CONNECTIONS; i++) begin: isaac_disabled_cache
        if ((i == L1_ICACHE_ID && !CONFIG.INCLUDE_ICACHE) ||
            (i == L1_DCACHE_ID && !CONFIG.INCLUDE_DCACHE)) begin: inactive
            assign l1_request[i].request = 1'b0;
            assign l1_request[i].addr = '0;
            assign l1_request[i].data = '0;
            assign l1_request[i].rnw = 1'b1;
            assign l1_request[i].be = '0;
            assign l1_request[i].size = '0;
            assign l1_request[i].is_amo = 1'b0;
            assign l1_request[i].amo = '0;
        end
    end endgenerate
'''
        if text.count('endmodule') != 1:
            raise ValueError('Unexpected CVA5 module layout')
        text = text.replace('endmodule', addition+'\nendmodule')
    elif name == 'scaiev_glue.sv':
        marker = 'else begin // !(ENABLE_DECOUPLED_WRITEBACK && ENABLE_DECOUPLED_WRITEBACK_WAW)'
        if text.count(marker) != 1:
            raise ValueError('Unexpected CVA5 decoupled writeback layout')
        text = text.replace(marker, marker+"\n        assign scaiev.renamer_addtofree_skip = 1'b0;")
    return text


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('source', type=Path)
    p.add_argument('output', type=Path)
    a = p.parse_args()
    a.output.write_text(adapt(a.source.name, a.source.read_text()))
