#ifndef INTERRUPT_H
#define INTERRUPT_H
extern void setInt8h();
extern void setInt9h();
extern void setInt21h();
extern void setInt22h();
extern void setInt23h();
extern void setInt24h();
extern void setInt25h();
extern void resetInt(int);

#include "Timer.h"

#endif // INTERRUPT_H
