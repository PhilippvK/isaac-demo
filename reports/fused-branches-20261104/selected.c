extern int taken(void); extern int missed(void);
__attribute__((noinline)) int FUNC(BEQ)(unsigned a,unsigned b) { if ((unsigned)(a&b) == (unsigned)7) return taken(); else return missed(); }
__attribute__((noinline)) int FUNC(BNE)(unsigned a,unsigned b) { if ((unsigned)(a&b) != (unsigned)7) return taken(); else return missed(); }
__attribute__((noinline)) int FUNC(BLT)(unsigned a,unsigned b) { if ((int)(a&b) < (int)7) return taken(); else return missed(); }
__attribute__((noinline)) int FUNC(BGE)(unsigned a,unsigned b) { if ((int)(a&b) >= (int)7) return taken(); else return missed(); }
__attribute__((noinline)) int FUNC(BLTU)(unsigned a,unsigned b) { if ((unsigned)(a&b) < (unsigned)7) return taken(); else return missed(); }
__attribute__((noinline)) int FUNC(BGEU)(unsigned a,unsigned b) { if ((unsigned)(a&b) >= (unsigned)7) return taken(); else return missed(); }
