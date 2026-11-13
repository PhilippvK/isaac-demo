// Run the post-frontend CVA5 netlist with ideal clock primitive stubs.
#include "Vcva5_arty_top.h"
#include "verilated.h"
#include <cstdio>
#include <string>
int main(int argc,char**argv) {
    Verilated::commandArgs(argc,argv);
    Vcva5_arty_top top;
    top.uart_rx=1;
    int timer=0,bit=-1,byte=0;
    bool busy=false,prev=true;
    std::string line;
    for(unsigned cycle=0;cycle<10000000;cycle++) {
        top.reset_button=cycle<10;
        top.clk100=0;top.eval();top.clk100=1;top.eval();
        bool tx=top.uart_tx;
        if(!busy && prev && !tx) {busy=true;timer=87;bit=-1;byte=0;}
        else if(busy && --timer==0) {
            if(bit==-1) {
                if(tx) {std::puts("BAD_START");return 2;}
                bit=0;timer=174;
            } else if(bit<8) {byte|=int(tx)<<bit++;timer=174;}
            else {
                if(!tx) {std::puts("BAD_STOP");return 2;}
                std::putchar(byte);std::fflush(stdout);busy=false;
                if(byte=='\n') {
                    if(line=="PASS") {std::printf("SIMULATION_PASS cycle=%u\n",cycle);return 0;}
                    if(line.find("FAIL")!=std::string::npos) return 1;
                    line.clear();
                } else if(byte!='\r') line+=char(byte);
            }
        }
        prev=tx;
    }
    std::puts("CPU_BOOT_TIMEOUT");return 1;
}
