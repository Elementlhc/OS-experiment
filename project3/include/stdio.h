#ifndef STDIO_H
#define STDIO_H

extern char getch();
extern void _printChar(char);

void putch(char c)
{
	if (c == '\n')
	{
		_printChar('\r');
	}
	_printChar(c);
}

void puts(const char* s)
{
	while(*s)  putch(*s++);
}

#endif // STDIO_H
