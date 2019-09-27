#include <stdint.h>

#include "wolfssl/wolfcrypt/settings.h"
#include "stm32wbxx_nucleo.h"
#include "wolfcrypt/test/test.h"
#include "wolfcrypt/benchmark/benchmark.h"
#include "uart.h"




int main(void) {
    uart_init();
    rng_init();
//    wolfcrypt_test(NULL);
    benchmark_test(NULL);
    return 0;
}


