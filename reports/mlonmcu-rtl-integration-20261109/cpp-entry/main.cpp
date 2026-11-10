#include <vector>
#include <cstdio>
static std::vector<int> values{13, 29};
struct Cleanup { ~Cleanup() { std::puts("C++ destructor check: PASS"); } };
static Cleanup cleanup;
int main() {
    int status = values.size() == 2 && values[0] + values[1] == 42 ? 0 : 7;
    std::printf("C++ constructor/heap check: %d\nMLONMCU EXIT: %d\n", status, status);
    const unsigned char bytes[] = {0, 255, 128, 10};
    std::fwrite(bytes, 1, sizeof(bytes), stdout);
    return status;
}
