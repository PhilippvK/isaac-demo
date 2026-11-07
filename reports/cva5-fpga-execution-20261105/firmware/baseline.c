typedef unsigned int u32;
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
int main(void) {
 UART[3]=3u;
 puts_uart("ISAAC CVA5 BOOT baseline\r\n");
 for (u32 i=0;i<16;i++) scratch[i]=0xa55a1234u^i;
 for (u32 i=0;i<16;i++) if (scratch[i]!=(0xa55a1234u^i)) {puts_uart("RAM FAIL\r\nFAIL\r\n");return 1;}
 puts_uart("RAM PASS\r\n");table_init();
 u32 start=cycles();u32 c=crc_run();u32 elapsed=cycles()-start;
 puts_uart("CRC32=");hex(c);puts_uart(" verify=");hex(c%32768u);puts_uart(" cycles=");hex(elapsed);puts_uart("\r\n");
 puts_uart(c%32768u==11433u?"PASS\r\n":"FAIL\r\n");return 0;
}
