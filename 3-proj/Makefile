#Makefile to create executable for proj3.S
all: calc

calc: proj3.S
	arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static -lm -mfpu=vfp -mfloat-abi=hard
