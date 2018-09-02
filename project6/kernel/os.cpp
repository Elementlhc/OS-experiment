__asm__(".code16gcc\n");
#include <stdio.h>
#include "terminal.h"

int main()
{
    setInt21h();
    
    addCommand("ls",       "ls             list all files in current work directory", ls);
    addCommand("info",     "info <file>    print detailed infomation of <file>", info);
    addCommand("clear",    "clear          clear window", clear);
    // addCommand("./",    "./ <file>      run <file>--a process"， run);
    addCommand("shutdown", "shutdown       power off", shutdown);
    addCommand("reboot",   "reboot         restart the computer", reboot);
    addCommand("help",     "help           see these tips", help);
    addCommand("multipro", "multipro       run 4 process in turn", multipro);

    ProcessTable::instance().addProcess(Process("program1.com", 0x4800, 0x49ff));
    ProcessTable::instance().addProcess(Process("program2.com", 0x4a00, 0x4bff));
    ProcessTable::instance().addProcess(Process("program3.com", 0x4c00, 0x4dff));
    ProcessTable::instance().addProcess(Process("program4.com", 0x4e00, 0x4fff));
    // addProgram("testInt.com", 0x4c00, 0x4dff, 0x1000);
    
    while(1) {
        char cmd[MAX_CMD_LEN+1] = {0};
        cout << "laomd@Dos:~$";
        getInput(cmd);
        if (*cmd)
        {
            system(cmd);
            memset(cmd, sizeof(cmd) * sizeof(char), 0);
        }
    }
    return 0;
}