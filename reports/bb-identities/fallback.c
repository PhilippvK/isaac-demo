int varsum(int n, ...) {
  __builtin_va_list ap;
  __builtin_va_start(ap, n);
  int sum = 0;
  for (int i = 0; i < n; ++i) sum += __builtin_va_arg(ap, int);
  __builtin_va_end(ap);
  return sum;
}
typedef int v4i __attribute__((vector_size(16)));
v4i vector_add(v4i a, v4i b) { return a + b; }
long double extended_add(long double a, long double b) { return a + b; }
