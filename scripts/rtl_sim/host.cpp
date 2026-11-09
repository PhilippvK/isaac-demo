#include "Vsim_top.h"
#include "verilated.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <vector>
static std::vector<uint8_t> ram(256*1024);
static uint64_t ticks=0, retired=0;
static bool done=false, fault=false;
static uint32_t status=0;
extern "C" unsigned int isaac_read(unsigned int addr) {
    addr &= ~3u;
    if (addr>=0x80000000u && uint64_t(addr)-0x80000000u+4<=ram.size()) {
        size_t p=addr-0x80000000u;
        return ram[p]|uint32_t(ram[p+1])<<8|uint32_t(ram[p+2])<<16|uint32_t(ram[p+3])<<24;
    }
    if (addr==0x60000004u || addr==0x60000008u || addr==0x6000000cu || addr==0x60000018u || (addr>=0x60000020u && addr<=0x60000028u)) return 0;
    if (addr==0x60000010u) return ticks;
    if (addr==0x60000014u) return retired;
    std::cerr<<"Unmapped read 0x"<<std::hex<<addr<<std::endl;
    fault=true; return 0;
}
extern "C" void isaac_write(unsigned int addr, unsigned int data, unsigned int mask) {
    addr &= ~3u;
    if (addr>=0x80000000u && uint64_t(addr)-0x80000000u+4<=ram.size()) {
        for (unsigned i=0;i<4;i++) if(mask&(1<<i)) ram[addr-0x80000000u+i]=(data>>(i*8))&255;
    } else if(addr==0x60000004u) { std::putchar(data&255); std::fflush(stdout); }
    else if(addr==0x60000018u) { status=data;done=true; }
    else if(addr==0x6000000cu) {}
    else if(addr>=0x60000020u && addr<=0x60000028u) {
        std::cerr<<"TRAP register 0x"<<std::hex<<addr<<" = 0x"<<data<<std::dec<<std::endl;
    } else { std::cerr<<"Unmapped write 0x"<<std::hex<<addr<<std::endl;fault=true; }
}
int main(int argc,char **argv) {
    Verilated::commandArgs(argc,argv);
    if(argc<3) {std::cerr<<"Usage: simulator firmware.bin max_cycles\n";return 2;}
    if(argc>3) ram.resize(std::strtoull(argv[3],nullptr,0));
    std::ifstream f(argv[1],std::ios::binary);
    std::vector<char> bytes((std::istreambuf_iterator<char>(f)),std::istreambuf_iterator<char>());
    if(!f || bytes.empty() || bytes.size()>ram.size()) {std::cerr<<"Invalid firmware size\n";return 2;}
    for(size_t i=0;i<bytes.size();i++) ram[i]=uint8_t(bytes[i]);
    Vsim_top top; top.clk=0;top.rst=1;
    uint64_t limit=std::strtoull(argv[2],nullptr,0);
    for(unsigned i=0;i<30;i++){top.clk=0;top.eval();top.clk=1;top.eval();}
    top.rst=0;
    while(!done && !fault && !Verilated::gotFinish() && ticks<limit) {
        top.clk=0;top.eval();
        retired+=top.retired;
        top.clk=1;top.eval(); ++ticks;
    }
    top.final();
    bool passed=done && !fault && status==0;
    std::cout<<"\nISAAC_RTL_RESULT exit="<<status<<" cycles="<<ticks<<" retired="<<retired
             <<" completed="<<done<<" passed="<<passed<<std::endl;
    return passed?0:1;
}
