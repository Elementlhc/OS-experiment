#ifndef STDIO_H
#define STDIO_H
#include "stdlib.h"
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

#endif // STDIO_H
