#include <sys/time.h>
#include "uart.h"

struct _reent;

int _gettimeofday_r(struct _reent *re, struct timeval *tv, void *tz)
{
    uint32_t tk = HAL_GetTick();
    uint32_t fr = HAL_GetTickFreq();

    if (tv) {
        tv->tv_sec = (tk / (1000 *fr));
        tv->tv_usec = (tk * fr) % 1000;
    }
    return 0;
}

