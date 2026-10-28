#include <stdint.h>
#include "cfu_soc.h"

extern void initialise_benchmark(void);
extern void warm_caches(int);
extern int benchmark(void);
extern int verify_benchmark(int);
#ifdef CFU_DISCOVERY
__attribute__((noinline)) void cfu_benchmark_end(void) {
    __asm__ volatile("" ::: "memory");
}
#endif

static uint32_t read_reg(uint32_t address) { return *(volatile uint32_t *)(uintptr_t)address; }
static void write_reg(uint32_t address, uint32_t value) { *(volatile uint32_t *)(uintptr_t)address = value; }
static void put_char(char ch) {
    while (read_reg(CFU_UART_TXFULL)) {}
    write_reg(CFU_UART_RXTX, (unsigned char)ch);
}
static void put_text(const char *text) { while (*text) put_char(*text++); }
static void put_hex(uint64_t value) {
    for (int shift = 60; shift >= 0; shift -= 4)
        put_char("0123456789abcdef"[(value >> shift) & 15]);
    put_char('\n');
}
static uint64_t cycles(void) {
    uint32_t hi, lo, again;
    do {
        __asm__ volatile("rdcycleh %0" : "=r"(hi) :: "memory");
        __asm__ volatile("rdcycle %0" : "=r"(lo) :: "memory");
        __asm__ volatile("rdcycleh %0" : "=r"(again) :: "memory");
    } while (hi != again);
    return ((uint64_t)hi << 32) | lo;
}
static uint64_t instructions(void) {
    uint32_t hi, lo, again;
    do {
        __asm__ volatile("rdinstreth %0" : "=r"(hi) :: "memory");
        __asm__ volatile("rdinstret %0" : "=r"(lo) :: "memory");
        __asm__ volatile("rdinstreth %0" : "=r"(again) :: "memory");
    } while (hi != again);
    return ((uint64_t)hi << 32) | lo;
}
int main(void) {
    initialise_benchmark();
    warm_caches(0);
    uint64_t begin_cycles = cycles();
    uint64_t begin_instructions = instructions();
    int result = benchmark();
    uint64_t end_instructions = instructions();
    uint64_t end_cycles = cycles();
#ifdef CFU_DISCOVERY
    cfu_benchmark_end();
#endif
    int valid = verify_benchmark(result);
    put_text("ISAAC_CFU_CYCLES_HEX="); put_hex(end_cycles - begin_cycles);
    put_text("ISAAC_CFU_INSTRUCTIONS_HEX="); put_hex(end_instructions - begin_instructions);
    put_text(valid == 1 ? "ISAAC_CFU_BENCH_PASS\n" : "ISAAC_CFU_BENCH_FAIL\n");
    while (!read_reg(CFU_UART_TXEMPTY)) {}
    write_reg(CFU_SIM_FINISH, 1);
    for (;;) {}
}
