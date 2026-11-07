__attribute__((noinline)) unsigned FUNC(MEM_ADDR_LB)(unsigned a,unsigned b,unsigned c){return *(const signed char *)(a+b);}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_LBU)(unsigned a,unsigned b,unsigned c){return *(const unsigned char *)(a+b);}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_LH)(unsigned a,unsigned b,unsigned c){return *(const short *)(a+b);}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_LHU)(unsigned a,unsigned b,unsigned c){return *(const unsigned short *)(a+b);}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_LW)(unsigned a,unsigned b,unsigned c){return *(const unsigned *)(a+b);}
__attribute__((noinline)) unsigned FUNC(MEM_LOADADD_LB)(unsigned a,unsigned b,unsigned c){return *(const signed char *)a+b;}
__attribute__((noinline)) unsigned FUNC(MEM_LOADADD_LBU)(unsigned a,unsigned b,unsigned c){return *(const unsigned char *)a+b;}
__attribute__((noinline)) unsigned FUNC(MEM_LOADADD_LH)(unsigned a,unsigned b,unsigned c){return *(const short *)a+b;}
__attribute__((noinline)) unsigned FUNC(MEM_LOADADD_LHU)(unsigned a,unsigned b,unsigned c){return *(const unsigned short *)a+b;}
__attribute__((noinline)) unsigned FUNC(MEM_LOADADD_LW)(unsigned a,unsigned b,unsigned c){return *(const unsigned *)a+b;}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_SB)(unsigned a,unsigned b,unsigned c){*(unsigned char *)(a+b)=c;return 0;}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_SH)(unsigned a,unsigned b,unsigned c){*(unsigned short *)(a+b)=c;return 0;}
__attribute__((noinline)) unsigned FUNC(MEM_ADDR_SW)(unsigned a,unsigned b,unsigned c){*(unsigned *)(a+b)=c;return 0;}
__attribute__((noinline)) unsigned FUNC(MEM_STOREXOR_SB)(unsigned a,unsigned b,unsigned c){*(unsigned char *)a=b^c;return 0;}
__attribute__((noinline)) unsigned FUNC(MEM_STOREXOR_SH)(unsigned a,unsigned b,unsigned c){*(unsigned short *)a=b^c;return 0;}
__attribute__((noinline)) unsigned FUNC(MEM_STOREXOR_SW)(unsigned a,unsigned b,unsigned c){*(unsigned *)a=b^c;return 0;}
