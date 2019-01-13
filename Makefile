CC = avr-gcc
CFLAGS = -Wall -Wextra -pedantic -O1
CFLAGS += -mmcu=atmega1284

.PHONY: all clean flash

all: clean main.hex

debug: CFLAGS += -DDEBUG
debug: clean main.hex

main: main.c kernel.c kernel_utils.S

main.hex: main
	avr-objcopy -j .text -j .data -O ihex $^ $@

flash: main.hex
	avrdude -c usbasp -p atmega1284 -U flash:w:main.hex:i

clean:
	rm -f main main.hex
