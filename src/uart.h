#ifndef __UART_H
#define __UART_H

#ifdef __cplusplus
extern "C" {
#endif

#include "stm32wbxx_hal.h"
#include "stm32wbxx_hal_uart.h"
#include <stdio.h>
#include "stm32wbxx_nucleo.h"
void Error_Handler(void);

#ifdef __cplusplus
}
#endif

int uart_init(void);
int rng_init(void);
uint32_t random_uint32(void);
#endif /* __UART_H */

