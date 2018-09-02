#ifndef PROGRAM_H
#define PROGRAM_H
#include <string.h>
#include "sector.h"
#include "interrupt.h"

extern void _restart(int,int,int);

struct PCB
{
    int ax;
    int bx;
    int cx;
    int dx;
    int si;
    int di;
    int bp;
    int es;
    int gs;
    int ds;
    int ss;
    int sp;
    int ip;
    int cs;
    int flags;

    enum Status
    {
        RUNNING, WAITING
    } status;
};

class Process : public Sector {
public:
    Process() { };

    Process(const char* process_name, int start_addr, int end_addr)
        : Sector(start_addr, end_addr)
    {
        setName(process_name);
    }

    Process(const Process& other)
    {
        setName(other._name);
        pcb = other.pcb;
    }

    ~Process() { };

    const char* getName() const 
    {
        return _name;
    }

    void setName(const char* new_name)
    {
        strncpy(_name, new_name, 20);
    }

    void loadToMemory(int load_addr)
    {
        Sector::loadToMemory(load_addr);
        save(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, load_addr - 4, load_addr, 0, 512);
    }

    void save(
        int ax, int bx, int cx, int dx,
        int si, int di, int bp,
        int es, int gs, int ds, int ss, int sp,
        int ip, int cs, int flags)
    {
        pcb.ax = ax;
        pcb.bx = bx;
        pcb.cx = cx;
        pcb.dx = dx;
        pcb.si = si;
        pcb.di = di;
        pcb.bp = bp;
        pcb.es = es;
        pcb.gs = gs;
        pcb.ds = ds;
        pcb.ss = ss;
        pcb.sp = sp;
        pcb.ip = ip;
        pcb.cs = cs;
        pcb.flags = flags;
        pcb.status = PCB::WAITING;
    }

    PCB pcb;
private:
    char _name[21];
};

#endif // PROGRAM_H
