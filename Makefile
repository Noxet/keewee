CC = avr-gcc
CFLAGS = -Wall -Wextra -pedantic -O1
CFLAGS += -mmcu=atmega1284

.PHONY: all clean

all: main.hex

main: main.c kernel.c kernel.h kernel_utils.S

main.hex: main
	avr-objcopy -j .text -j .data -O ihex $^ $@

clean:
	rm -f main main.hex
