#ifndef OS_C_H
#define OS_C_H
#include "command.h"

int isvalid(char c)
{
    return isalpha(c) || isdigit(c) || isspace(c) || c == '.' || c == '/' || c == '\b';
}

void tabComplete(char* cmd)
{
    for (int i = 0; i < num_cmd; ++i)
    {
        const char* cmd_name = all_commands[i].name;
        const char* pos = mismatch(cmd_name, cmd);
        int len = pos - cmd_name;
        if (*(cmd+len) == 0)
        {
            cout << pos;
            strcpy(cmd+len, pos);
            break;
        }
    }
}

void printBack()
{
    cout << "\b \b";
}

void getInput(char* cmd)
{
    int len = 0;

    char c;
    cin >> c;
    
    while(c != '\r' && c != '\n') {
        if (isvalid(c))
        {
            if (c == '\b')
            {
                if (len > 0)
                {
                    cout << ' ' << c;
                    cmd[--len] = 0;
                }
                else
                    cout << '$';
            }
            else 
            {
                if (len < MAX_CMD_LEN)
                {
                    if (c == '\t')
                    {
                        printBack();
                        if (len > 0)
                        {
                            tabComplete(cmd);
                            len = strlen(cmd);
                        }
                    }
                    else
                    {
                        cmd[len++] = c;
                    }
                }
                else
                {
                    printBack();
                }
            }
        }
        else    printBack();
        cin >> c;
    }
}

void system(char* cmd)
{
    cmd = lstrip(cmd);
    rstrip(cmd);
    char whichCMD[MAX_CMD_LEN+1] = {0};
    int len = 0;
    while(!isspace(*cmd) && *cmd) {
        whichCMD[len++] = *cmd++;
    }
    if (len)
    {
        while(isspace(*cmd)) {
            cmd++;
        }
        
        for (int i = 0; i < num_cmd; ++i)
        {
            if (strcmp(whichCMD, all_commands[i].name) == 0)
            {
                all_commands[i].func(cmd);
                return;
            }
        }
        cout << "Invalid command " << whichCMD << endl;
    }
}

#endif // OS_C_H
