#ifndef COMMAND_H
#define COMMAND_H

#define MAX_CMD_LEN 20
#include <string.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include "process_table.h" 
using namespace laomd;

typedef void(*funcType)(const char*);
typedef struct Command {
    char name[MAX_CMD_LEN+1];
    char tips[80+1];
    funcType func;

} Command;

Command all_commands[10];
int num_cmd = 0;

void addCommand(const char* cmd, const char* tips, funcType func)
{
    strncpy(all_commands[num_cmd].name, cmd, MAX_CMD_LEN);
    strncpy(all_commands[num_cmd].tips, tips, 80);
    all_commands[num_cmd].func = func;
    num_cmd++;
}

void doNoArgvCmd(const char* argv, void(*func)())
{
    if (*argv)
    {
        cout << "Invalid operand " << argv << endl;
    }
    else
    {
        func();
    }
}

void visitProcess(const char* argv, void(*visit)(Process&))
{
    if (*argv == 0)
    {
        cout << "Need input file." << endl;
    }
    else
    {
        for(auto& p : ProcessTable::instance()) {
            if(strcmp(p.getName(), argv) == 0) {
                visit(p);
                return;
            }
        }
        cout << "can not find file " << argv << endl;
    }
}

void _list()
{
    for(const auto& p : ProcessTable::instance()) {
        cout << p.getName() << ' ';
    }
    cout << endl;
}

void ls(const char* argv)
{
    doNoArgvCmd(argv, _list);
}

void clear(const char* argv)
{
    doNoArgvCmd(argv, cls);
}

void shutdown(const char* argv)
{
    doNoArgvCmd(argv, _shutdown);
}

void reboot(const char* argv)
{
    doNoArgvCmd(argv, reboot);
}

void _help()
{
    for (int i = 0; i < num_cmd; ++i)
    {
        cout << all_commands[i].tips << endl;
    }
    cout << "use tab to enjoy complement!" << endl;
}

void help(const char* argv)
{
    doNoArgvCmd(argv, _help);
}

void _multipro()
{
    int load = 0x1000;
    for(auto& program : ProcessTable::instance()) {
        program.loadToMemory(load);
        num_loaded++;
        load += 0x1000;
    }
    setInt8h();
    while(num_loaded != 0);
    resetInt(8);
    cout << "done" << endl;
}

void multipro(const char* argv)
{
    doNoArgvCmd(argv, _multipro);
}

void printProcessInfo(Process& process)
{
    cout << "Name: " << process.getName() << endl;

    char str[10] = {0};
    const char* s[] = {"Bytes", "Cylinder", "Track", "Sector"};
    int infos[] = {process.bytes(), process.cylinder(), process.track(), process.indexOfFloppy()};
    int n = sizeof(infos) / sizeof(*infos);
    for (int i = 0; i < n; ++i)
    {
        cout << s[i] << ":  ";
        itos(infos[i], str);
        cout << str << endl;
        memset(str, sizeof(str) * sizeof(char), 0);
    }
}

void info(const char* argv)
{
    visitProcess(argv, printProcessInfo);
}

#endif // COMMAND_H
