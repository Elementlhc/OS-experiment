#ifndef STDIO_H
#define STDIO_H
#include <stdlib.h>
#include <string.h>

extern char getch();
extern void _printChar(char);

void putch(char c)
{
	_printChar(c);
}

void puts(const char* s)
{
	while(*s)  putch(*s++);
}

void putInt(int num)
{
	char s[20] = {0};
	itos(num, s);
	puts(s);
}

#endif // STDIO_H
