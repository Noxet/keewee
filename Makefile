CC = avr-gcc
AS = avr-as
CFLAGS = -Wall -Wextra -pedantic -O1
CFLAGS += -mmcu=atmega1284
ASFLAGS = $(CFLAGS)
LDLIBS = -L. -lkernel

.PHONY: all lib clean flash

all: main.hex

debug: CFLAGS += -DDEBUG
debug: main.hex

# build kernel library
kernel_utils.o: kernel_utils.S

kernel.o: kernel.c

libkernel.a: kernel.o kernel_utils.o
	avr-ar rcs $@ $^

lib: libkernel.a

# build application
main: main.c libkernel.a

main.hex: main
	avr-objcopy -j .text -j .data -O ihex $^ $@


flash: main.hex
	avrdude -c usbasp -p atmega1284 -U flash:w:main.hex:i

clean:
	rm -f kernel.o kernel_utils.o libkernel.a main main.hex
