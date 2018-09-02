#ifndef STDLIB_H
#define STDLIB_H

extern void Load(int,int,int,int,int);
extern void Run(int);
extern void _cls(int,int,int,int);
extern void _setCursor(int,int);
extern int _getCursor();
extern void _delay(int,int);
extern void _port_out(int,int);

void cls()
{
	_cls(1,1,23,78);
	_setCursor(1,1);
}

void _shutdown()
{
	_port_out(0x1004, 0x2001);
}

void getCursorPosition(int* row, int* col)
{
	int pos = _getCursor();
	*col = (pos & 0xff);
	*row = (pos >> 8);
}

void setCursorForNewLine()
{
	int row, col;
	getCursorPosition(&row, &col);
	col = 1;
	_setCursor(row, col);
}

void sleep(int ms)
{
	ms *= 1000;
	int h = ms / 0x10000;
	int l = ms % 0x10000;
	_delay(h,l);
}

#endif // STDLIB_H
