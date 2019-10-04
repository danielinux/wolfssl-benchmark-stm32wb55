CROSS_COMPILE:=arm-none-eabi-
CC:=$(CROSS_COMPILE)gcc
LD:=$(CROSS_COMPILE)gcc
AS:=$(CROSS_COMPILE)gcc
OBJCOPY:=$(CROSS_COMPILE)objcopy
SIZE:=$(CROSS_COMPILE)size

WOLFSSL_BUILD=./build/wolfssl
STM32CUBE_BUILD=./build/stm32cube

WOLFSSL_ROOT:=$(HOME)/src/wolfssl
STM32CUBE_ROOT:=$(HOME)/src/STM32CubeWB/STM32Cube_FW_WB_V1.2.0
DEBUG?=0
CFLAGS=-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS+=-mthumb -Wall -Wextra -Wno-main -Wstack-usage=1024 -ffreestanding -Wno-unused \
		-Isrc -I$(STM32CUBE_ROOT)/Drivers/BSP/P-NUCLEO-WB55.Nucleo/ -I$(STM32CUBE_ROOT)/Drivers/CMSIS/Device/ST/STM32WBxx/Include \
	-DWOLFSSL_USER_SETTINGS -I$(WOLFSSL_ROOT)  -I$(STM32CUBE_ROOT)/Drivers/STM32WBxx_HAL_Driver/Inc/ \
	-I$(STM32CUBE_ROOT)/Drivers/CMSIS/Include \
	-mthumb -mlittle-endian -mthumb-interwork -ffreestanding -fno-exceptions -DSTM32WB55xx

ifneq ($(DEBUG),0)
  CFLAGS+=-O0 -ggdb3
else
  CFLAGS+=-Os
endif


LDFLAGS=$(CFLAGS) -Wl,-gc-sections -ffreestanding -nostartfiles -lc -u _printf_float -lnosys -specs=nano.specs -Wl,-Map=image.map

OBJS:= \
  src/main.o \
  src/startup.o \
  src/gettimeofday.o \
  src/stm32wbxx_hal_msp.o \
  src/stm32wbxx_it.o \
  src/system_stm32wbxx.o \
  src/uart.o \
  src/syscalls.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_pka.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_uart.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_uart_ex.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_dma.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_cortex.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_gpio.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_rcc.o  \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_rcc_ex.o  \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_pwr_ex.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_pwr.o \
  $(STM32CUBE_BUILD)/Drivers/stm32wbxx_hal_rng.o\
  $(STM32CUBE_BUILD)/BSP/stm32wbxx_nucleo.o

WOLFSSL_OBJS += 	\
    $(WOLFSSL_BUILD)/internal.o \
	$(WOLFSSL_BUILD)/wolfio.o \
    $(WOLFSSL_BUILD)/keys.o \
    $(WOLFSSL_BUILD)/crl.o \
	$(WOLFSSL_BUILD)/wolfcrypt/aes.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/asn.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/chacha.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/chacha20_poly1305.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/coding.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/curve25519.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/error.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/ecc.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/ed25519.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/rsa.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/fe_low_mem.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/fe_operations.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/ge_low_mem.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/ge_operations.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/hash.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/hmac.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/integer.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/logging.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/md5.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/memory.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/poly1305.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/pwdbased.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/random.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/sha.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/sha256.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/sha512.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/wc_encrypt.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/wc_port.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/wolfmath.o \
	$(WOLFSSL_BUILD)/wolfcrypt/tfm.o  \
	$(WOLFSSL_BUILD)/wolfcrypt/dh.o \
	$(WOLFSSL_BUILD)/wolfcrypt/benchmark/benchmark.o \
	$(WOLFSSL_BUILD)/wolfcrypt/test/test.o \
	$(WOLFSSL_BUILD)/wolfcrypt/port/st/stm32.o
	
OBJS_SPMATH:= $(WOLFSSL_BUILD)/wolfcrypt/sp_c32.o  \
 		 		$(WOLFSSL_BUILD)/wolfcrypt/sp_int.o

OBJS+=$(WOLFSSL_OBJS) $(OBJS_SPMATH)

vpath %.c $(dir $(WOLFSSL_ROOT)/src)
vpath %.c $(dir $(WOLFSSL_ROOT)/wolfcrypt/src)
vpath %.c $(dir $(WOLFSSL_ROOT)/wolfcrypt/benchmark)
vpath %.c $(dir $(WOLFSSL_ROOT)/wolfcrypt/test)
vpath %.c $(dir $(WOLFSSL_ROOT)/wolfcrypt/port/st)
vpath %.c $(dir $(STM32CUBE_ROOT)/Drivers/STM32WBxx_HAL_Driver/Src)
vpath %.c $(dir $(STM32CUBE_ROOT)/Drivers/BSP/P-NUCLEO-WB55.Nucleo/)

LSCRIPT:=stm32wb55.ld

all: image.bin

$(WOLFSSL_BUILD)/wolfcrypt/port/st:
	mkdir -p $(@)

$(WOLFSSL_BUILD)/wolfcrypt/benchmark:
	mkdir -p $(@)

$(WOLFSSL_BUILD)/wolfcrypt/test:
	mkdir -p $(@)

$(STM32CUBE_BUILD)/Drivers:
	mkdir -p $(@)

$(STM32CUBE_BUILD)/BSP:
	mkdir -p $(@)

%.o:%.S
	$(CC) -c -o $(@) $(CFLAGS) $^

%.o:%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(WOLFSSL_BUILD)/%.o: $(WOLFSSL_ROOT)/src/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(WOLFSSL_BUILD)/wolfcrypt/%.o: $(WOLFSSL_ROOT)/wolfcrypt/src/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(WOLFSSL_BUILD)/wolfcrypt/benchmark/%.o: $(WOLFSSL_ROOT)/wolfcrypt/benchmark/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(WOLFSSL_BUILD)/wolfcrypt/test/%.o: $(WOLFSSL_ROOT)/wolfcrypt/test/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(WOLFSSL_BUILD)/wolfcrypt/port/st/%.o: $(WOLFSSL_ROOT)/wolfcrypt/port/st/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(STM32CUBE_BUILD)/Drivers/%.o: $(STM32CUBE_ROOT)/Drivers/STM32WBxx_HAL_Driver/Src/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^

$(STM32CUBE_BUILD)/BSP/%.o: $(STM32CUBE_ROOT)/Drivers/BSP/P-NUCLEO-WB55.Nucleo/%.c
	$(CC) -c -o $(@) $(CFLAGS) $^


image.bin: image.elf
	$(OBJCOPY) -O binary $^ $@
	$(SIZE) image.elf

image.hex: image.elf
	$(OBJCOPY) -O ihex $^ $@

image.elf: $(WOLFSSL_BUILD)/wolfcrypt/test $(WOLFSSL_BUILD)/wolfcrypt/port/st $(WOLFSSL_BUILD)/wolfcrypt/benchmark $(STM32CUBE_BUILD)/Drivers $(STM32CUBE_BUILD)/BSP $(OBJS) $(LSCRIPT)
	$(LD) $(LDFLAGS) -Wl,--start-group $(OBJS) -Wl,--end-group -o $@ -T $(LSCRIPT)

clean:
	@rm -rf build/
	@rm -f *.bin *.elf $(OBJS) wolfboot.map *.bin  *.hex src/*.o *.map tags

FORCE:
