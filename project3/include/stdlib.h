#ifndef STDLIB_H
#define STDLIB_H

extern void Load(int,int,int,int,int);
extern void _cls();
extern void _delay(int,int);
extern void _port_out(int,int);

void cls()
{
	_cls();
}

void _shutdown()
{
	_port_out(0x1004, 0x2001);
}

void sleep(int ms)
{
	ms *= 1000;
	int h = ms / 0x10000;
	int l = ms % 0x10000;
	_delay(h,l);
}

#endif // STDLIB_H
