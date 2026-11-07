extern int side(int);
int choose(int a, int b) { return a < b ? a + 3 : b - 5; }
int loop(int *p, int n) {
  int s = 0;
  for (int i = 0; i < n; ++i) {
    if (p[i] & 1) s += side(p[i]);
    else s ^= p[i];
  }
  return s;
}
int dispatch(int x) {
  switch (x) {
  case 1: return side(8);
  case 4: return side(3) + 2;
  case 9: return x + 7;
  default: return x ^ 42;
  }
}
