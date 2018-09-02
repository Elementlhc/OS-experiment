__asm__(".code16gcc\n");
#include "../include/stdio.h"
#include "../include/string.h"
#include "terminal.h"

void printBack()
{
	putch('\b');
	putch(' ');
	putch('\b');
}

void main()
{
	setInt8h();
	setInt21h();
	setInt22h();
	setInt23h();
	setInt24h();
	setInt25h();

	addCommand("ls", ls);
	addCommand("info", info);
	addCommand("clear", clear);
	addCommand("./", run);
	addCommand("shutdown", shutdown);
	addCommand("help", help);

	addProgram("play.com", 0x4e00, 0x4fff, 0x1000);
	addProgram("program1.com", 0x4800, 0x49ff, 0x1000);
	addProgram("program2.com", 0x4a00, 0x4bff, 0x1000);
	addProgram("testInt.com", 0x4c00, 0x4dff, 0x1000);

	putch('\r');
	while(1) {
	    char cmd[MAX_CMD_LEN+1] = {0};

		puts("laomd@Dos:~$");
		int len = 0;

		int ok = 0;
		char c = getch();
		
		while(c != '\r' && c != '\n') {
			if (isvalid(c))
			{
				if (c == '\b')
				{
					if (len > 0)
					{
						putch(' ');
						putch(c);
						cmd[--len] = 0;
					}
					else
						putch('$');
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
			c = getch();
		}
		if (len > 0)
		{
			system(cmd);
		}
	}
}