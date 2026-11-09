/* Host services supplied by the RTL simulation bus adapter, not semihosting. */
#include <stdint.h>
#include <stddef.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <errno.h>
#define REG(a) (*(volatile uint32_t *)(a))
uint64_t target_cycles(void) { return REG(0x60000010); }
uint64_t target_instructions(void) { return REG(0x60000014); }
uint64_t target_time(void) { return target_cycles(); }
int _write(int fd, const void *buf, size_t n) {
  (void)fd; const unsigned char *s = buf;
  for (size_t i=0; i<n; ++i) REG(0x60000004)=s[i];
  return n;
}
__attribute__((noreturn)) void _exit(int status) {
  REG(0x60000018)=(uint32_t)status;
  for (;;) __asm__ volatile("nop");
}
void trap_report(uint32_t cause, uint32_t pc, uint32_t value) {
  REG(0x60000020)=cause; REG(0x60000024)=pc; REG(0x60000028)=value;
  _exit(128);
}
extern char __bss_end[], __stack_top[];
void *_sbrk(ptrdiff_t incr) {
  static char *end; if (!end) end=__bss_end;
  if (incr<0 || incr>(__stack_top-8192-end)) { errno=ENOMEM; return (void *)-1; }
  char *old=end; end+=incr; return old;
}
int _close(int fd) { (void)fd; return -1; }
int _fstat(int fd, struct stat *s) { (void)fd; s->st_mode=S_IFCHR; return 0; }
int _isatty(int fd) { (void)fd; return 1; }
int _lseek(int fd, int off, int whence) { (void)fd; (void)off; (void)whence; return 0; }
int _read(int fd, void *buf, size_t n) { (void)fd; (void)buf; (void)n; return 0; }
int _getpid(void) { return 1; }
int _kill(int pid, int sig) { (void)pid; (void)sig; errno=EINVAL; return -1; }
int _gettimeofday(struct timeval *tv, void *tz) {
  (void)tz; uint64_t t=target_cycles(); tv->tv_sec=t/1000000; tv->tv_usec=t%1000000; return 0;
}
