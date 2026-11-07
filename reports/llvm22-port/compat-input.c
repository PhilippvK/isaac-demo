volatile unsigned sink;
__attribute__((noinline)) unsigned choose(unsigned x) {
  if (x > 7) { sink = x; return x * 3; }
  sink = x + 1; return x + 1;
}
void _start(void) { sink = choose(sink); for (;;) {} }
