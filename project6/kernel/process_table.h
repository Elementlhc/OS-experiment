#ifndef PROCESS_TABLE_H
#define PROCESS_TABLE_H

#include <vector>
#include "process.h"

extern int getip();
extern void Timer_done();
extern void sendPCB(int,int,int,int,int,int,int,int,int,int,int,int,int,int,int);

int num_loaded = 0;
class ProcessTable
{
    ProcessTable() 
    {
        reset();
    }

    ~ProcessTable()
    {
        if(_instance) {
            delete _instance;
        }
    }
    ProcessTable(const ProcessTable&) = delete;
    ProcessTable& operator=(const ProcessTable&) = delete;

    void reset()
    {
        _cur_pid = -1;
        _cur_cnt_sch = 0;
        num_loaded = 0;
    }
public:
    typedef Vector<Process>::iterator iterator;
    typedef Vector<Process>::const_iterator const_iterator;

    static ProcessTable& instance()
    {
        if(_instance == nullptr) {
            _instance = new ProcessTable;
        }
        return *_instance;
    }

    bool empty() const
    {
        return process_table.empty();
    }

    int size() const
    {
        return process_table.size();
    }

    void addProcess(const Process& process)
    {
        process_table.push_back(process);
    }

    Process* curPro()
    {
        if(_cur_pid == -1) {
            return 0;
        }
        else
        {
            return &(process_table[_cur_pid]);
        }
    }

    void schedule()
    {
        if(!empty() && _cur_cnt_sch < maxSchd) {
            int tmp = _cur_pid;
            tmp = (tmp + 1) % size();
            while(tmp != _cur_pid && process_table[tmp].pcb.status != PCB::WAITING) {
                tmp = (tmp + 1) % size();
            }
            if(process_table[tmp].pcb.status == PCB::WAITING) {
                _cur_pid = tmp;
                ++_cur_cnt_sch;
            }
            else
            {
                reset();
            }
        }
        else
        {
            reset();
            Timer_done();

        }
    }

    const_iterator begin() const
    {
        return process_table.begin();
    }

    iterator begin()
    {
        return process_table.begin();
    }

    const_iterator end() const 
    {
        return process_table.end();
    }

    iterator end()
    {
        return process_table.end();
    }

private:
    static ProcessTable* _instance;
    Vector<Process> process_table;
    int _cur_pid;
    int _cur_cnt_sch;
    static const int maxSchd = 100;
};

ProcessTable* ProcessTable::_instance = nullptr;

void saveProcess(
    int ax, int bx, int cx, int dx,
    int si, int di, int bp,
    int es, int gs, int ds, int ss, int sp,
    int ip, int cs, int flags)
{
    ProcessTable& table = ProcessTable::instance();
    Process* cur = table.curPro();
    if(cur) {
        cur->save(ax,bx,cx,dx,si,di,bp,es,gs,ds,ss,sp,ip,cs,flags);
    }
}

void schedule()
{
    ProcessTable::instance().schedule();
}

void sendCurPro()
{
    Process* curPro = ProcessTable::instance().curPro();
    sendPCB(
        curPro->pcb.ax,
        curPro->pcb.bx,
        curPro->pcb.cx,
        curPro->pcb.dx,
        curPro->pcb.si,
        curPro->pcb.di,
        curPro->pcb.bp,
        curPro->pcb.es,
        curPro->pcb.gs,
        curPro->pcb.ds,
        curPro->pcb.ss,
        curPro->pcb.sp,
        curPro->pcb.ip,
        curPro->pcb.cs,
        curPro->pcb.flags);
}

#endif // PROCESS_TABLE_H
