__asm__(".code16gcc\n");
#include "../include/stdio.h"
#include "../include/string.h"
#include "terminal.h"

void main()
{
	addCommand("ls", ls);
	addCommand("info", info);
	addCommand("clear", clear);
	addCommand("./", run);
	addCommand("shutdown", shutdown);
	addCommand("help", help);

	addProgram("sorry.com", 0x1A00, 0x72eb, 0x1000);
	addProgram("rabbit.com", 0x7400, 0xc527, 0x1000);
	while(1) {  
	    char cmd[MAX_CMD_LEN+1] = {0};
		puts("laomd@Dos:~$");
		int len = 0;
		char c = getch();

		while(c != '\r' && c != '\n') {
			if (isvalid(c))
			{
				if (c == '\b')
				{
					if (len > 0)
					{
						putch(c);
						putch(' ');
						putch(c);
						cmd[--len] = 0;
					}
				}
			    else if (len < MAX_CMD_LEN)
				{
					if (c == '\t')
					{
						if (len > 0)
						{
							tabComplete(cmd);
							len = strlen(cmd);
						}
					}
					else
					{
						putch(c);
						cmd[len++] = c;
					}
				}
			}
			c = getch();
		}
		putch('\n');
		if (len > 0)
		{
			system(cmd);
		}
	}
}