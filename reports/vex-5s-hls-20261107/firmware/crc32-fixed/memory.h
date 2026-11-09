/* Generated from /var/tmp/ga87puy/isaac-demo-new/reports/vex-5s-hls-20261107/hls-inputs/crc32-fixed/XIsaac.hls.core_desc */
static inline u32 ise_CUSTOM0(u32 a,u32 b) { u32 r; __asm__ volatile(".insn r 11, 2, 0, %0, %1, %2":"=r"(r):"r"(a),"r"(b):"memory");return r; }
static inline u32 ise_check_x0(u32 a,u32 b) { u32 r; __asm__ volatile(".insn r 11, 2, 0, zero, %1, %2\n\taddi %0, zero, 0":"=r"(r):"r"(a),"r"(b):"memory");return r; }
static inline u32 ise_CUSTOM5(u32 a,u32 b) { u32 r; __asm__ volatile(".insn r 11, 2, 16, %0, %1, %2":"=r"(r):"r"(a),"r"(b):"memory");return r; }
static inline u32 ise_CUSTOM3(u32 a,u32 b) { u32 r; __asm__ volatile(".insn r 11, 2, 96, %0, %1, %2":"=r"(r):"r"(a),"r"(b):"memory");return r; }
static inline u32 ise_CUSTOM15(u32 a,u32 b) { u32 r; __asm__ volatile(".insn r 11, 2, 64, %0, %1, %2":"=r"(r):"r"(a),"r"(b):"memory");return r; }
static inline u32 ise_CUSTOM16(u32 a,u32 b) { u32 r; __asm__ volatile(".insn r 11, 2, 32, %0, %1, %2":"=r"(r):"r"(a),"r"(b):"memory");return r; }
#define ise_crc_masked ise_CUSTOM0
#define ise_index ise_CUSTOM5
#define ise_load_xor_shift ise_CUSTOM3
#define ise_offset ise_CUSTOM15
#define ise_load_xor ise_CUSTOM16
