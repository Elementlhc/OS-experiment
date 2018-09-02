#ifndef OS_C_H
#define OS_C_H
#include "../include/ctype.h"
#include "../include/string.h"
#include "command.h"

int isvalid(char c)
{
	return isalpha(c) || isdigit(c) || isspace(c) || c == '.' || c == '/' || c == '\b';
}

void tabComplete(char* cmd)
{
	if (starts_with(cmd, "./"))
	{
		cmd += 2;
		for (int i = 0; i < num_program; ++i)
		{
			const char* process_name = all_programs[i].name;
			const char* pos = mismatch(process_name, cmd);
			int len = pos - process_name;
			if (*(cmd+len) == 0)
			{
				puts(pos);
				strcpy(cmd+len, pos);
				break;
			}
		}
	}
	else
	{
		for (int i = 0; i < num_cmd; ++i)
		{
			const char* cmd_name = all_commands[i].name;
			const char* pos = mismatch(cmd_name, cmd);
			int len = pos - cmd_name;
			if (*(cmd+len) == 0)
			{
				puts(pos);
				strcpy(cmd+len, pos);
				break;
			}
		}
	}
}

void system(const char* cmd)
{
	char whichCMD[MAX_CMD_LEN+1] = {0};
	int len = 0;
	while(!isspace(*cmd) && *cmd != '/' && *cmd) {
	    whichCMD[len++] = *cmd++;
	}
	if (len)
	{
		if (*cmd == '/')
		{
			++cmd;
		}
		while(isspace(*cmd)) {
		    cmd++;
		}
		
		if (strcmp(whichCMD, ".") == 0)
		{
			whichCMD[1] = '/';
			whichCMD[2] = 0;
		}
		for (int i = 0; i < num_cmd; ++i)
		{
			if (strcmp(whichCMD, all_commands[i].name) == 0)
			{
				all_commands[i].func(cmd);
				return;
			}
		}
		puts("Invalid command ");
		puts(whichCMD);
		putch('\n');
	}
}

#endif // OS_C_H
