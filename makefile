CC=clang
all:
	rm -f l && $(CC) -DLT -ffast-math -fno-unwind-tables -fno-stack-protector -O3 m.c -o l
	time ./l
	rm -f r && $(CC) -ULT -ffast-math -fno-unwind-tables -fno-stack-protector -O3 m.c -o r
	time ./r
