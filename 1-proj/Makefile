# Makefile to execute proj1.S
all: proj1.out other.out

proj1.out: proj1.S
	arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static
other.out: other.S
	arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static
