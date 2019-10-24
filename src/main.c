#include <stdint.h>

#include "wolfssl/wolfcrypt/settings.h"
#include "stm32wbxx_nucleo.h"
#include "wolfcrypt/test/test.h"
#include "wolfcrypt/benchmark/benchmark.h"
#include "uart.h"


int ecc_test(void);

int main(void) {
    int r;
    uart_init();
    rng_init();
    pka_init();
    printf("Starting wolfCrypt test.\n");
    r = wolfcrypt_test(NULL);
    printf("Test result: %d\n", r);
    benchmark_test(NULL);
    return 0;
}


