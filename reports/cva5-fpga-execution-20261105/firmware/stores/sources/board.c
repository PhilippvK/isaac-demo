typedef unsigned int u32;
#ifndef BOARD_VARIANT
#define BOARD_VARIANT "baseline"
#endif
#ifdef ISAAC_MEMORY_HEADER
#include ISAAC_MEMORY_HEADER
#endif
#define UART ((volatile u32 *)0x60000000u)
static void putc_uart(char c) { while (UART[2] & 8u) {} UART[1] = (unsigned char)c; }
static void puts_uart(const char *s) { while (*s) putc_uart(*s++); }
static void hex(u32 n) { for (int i=28;i>=0;i-=4) putc_uart("0123456789abcdef"[(n>>i)&15]); }
static u32 cycles(void) { u32 n; __asm__ volatile("csrr %0, mcycle":"=r"(n)::"memory"); return n; }
void trap_report(u32 cause,u32 pc,u32 value) { puts_uart("TRAP cause=");hex(cause);puts_uart(" pc=");hex(pc);puts_uart(" value=");hex(value);puts_uart("\r\nFAIL\r\n"); for (;;) {} }
static volatile u32 table[256];
static volatile u32 scratch[16];
static void table_init(void) { for (u32 i=0;i<256;i++) {u32 c=i; for (int j=0;j<8;j++) c=(c>>1)^((0u-(c&1u))&0xedb88320u);table[i]=c;} }
__attribute__((noinline)) static u32 crc_run(void) {
 u32 crc=~0u, seed=0;
 for (u32 i=0;i<1024;i++) {
  seed=(seed*1103515245u+12345u)&0x7fffffffu;
  crc=table[(crc^(seed>>16))&255u]^(crc>>8);
 }
 return ~crc;
}
#ifdef ISAAC_MEMORY_HEADER
static int memory_checks(void) {
 for (u32 i=0;i<256;i++) {
  u32 expected=table[i],a=(u32)table,b=0xa5f08000u^i;
  u32 got[5]={ise_CUSTOM17(i|0xdeadbe00u,a),ise_CUSTOM43(i,a),ise_CUSTOM44(a+4*i,b),ise_CUSTOM76(4*i,a),ise_CUSTOM78(a+4*i,b)};
  u32 want[5]={expected,expected,expected^(b>>8),expected,expected^b};
  for (u32 j=0;j<5;j++) if (got[j]!=want[j]) {
   puts_uart("MEMORY FAIL index=");hex(i);puts_uart(" probe=");hex(j);puts_uart(" got=");hex(got[j]);puts_uart(" want=");hex(want[j]);puts_uart("\r\n");return 1;
  }
 }
 puts_uart("MEMORY PASS checks=00000500\r\n");return 0;
}
__attribute__((noinline)) static u32 crc_ise(void) {
 u32 crc=~0u,seed=0;
 for (u32 i=0;i<1024;i++) {
  seed=(seed*1103515245u+12345u)&0x7fffffffu;
  crc=ise_CUSTOM17(crc^(seed>>16),(u32)table)^(crc>>8);
 }
 return ~crc;
}
#endif
#if defined(ISAAC_BRANCHES) || defined(ISAAC_STORES)
#include "effect_checks.h"
#endif
int main(void) {
 UART[3]=3u;
 puts_uart("ISAAC CVA5 BOOT " BOARD_VARIANT "\r\n");
 for (u32 i=0;i<16;i++) scratch[i]=0xa55a1234u^i;
 for (u32 i=0;i<16;i++) if (scratch[i]!=(0xa55a1234u^i)) {puts_uart("RAM FAIL\r\nFAIL\r\n");return 1;}
 puts_uart("RAM PASS\r\n");table_init();
 u32 start=cycles();u32 c=crc_run();u32 elapsed=cycles()-start;
 puts_uart("CRC32=");hex(c);puts_uart(" verify=");hex(c%32768u);puts_uart(" cycles=");hex(elapsed);puts_uart("\r\n");
 if (c%32768u!=11433u) { puts_uart("FAIL\r\n");return 1; }
#ifdef ISAAC_MEMORY_HEADER
 if (memory_checks()) {puts_uart("FAIL\r\n");return 1;}
 for (u32 run=0;run<5;run++) {
  start=cycles();c=crc_run();u32 native_cycles=cycles()-start;
  start=cycles();u32 extended=crc_ise();u32 ise_cycles=cycles()-start;
  puts_uart("PAIR run=");hex(run);puts_uart(" native=");hex(c);puts_uart(" ise=");hex(extended);puts_uart(" native_cycles=");hex(native_cycles);puts_uart(" ise_cycles=");hex(ise_cycles);puts_uart("\r\n");
  if (extended!=c || (extended%32768u)!=11433u) {puts_uart("FAIL\r\n");return 1;}
 }
#endif
#if defined(ISAAC_BRANCHES) || defined(ISAAC_STORES)
 if (effect_checks()) {puts_uart("FAIL\r\n");return 1;}
#endif
 puts_uart("PASS\r\n");return 0;
}
