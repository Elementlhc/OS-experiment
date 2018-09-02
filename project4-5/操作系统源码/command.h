#ifndef COMMAND_H
#define COMMAND_H
#define MAX_CMD_LEN 20
#include "../include/string.h"
#include "../include/stdlib.h"
#include "program.h"
#include "interrupt.h"

typedef void(*funcType)(const char*);
typedef struct Command {
	char name[MAX_CMD_LEN+1];
	funcType func;
} Command;

Command all_commands[10];
int num_cmd = 0;

void addCommand(const char* cmd, funcType func)
{
	strncpy(all_commands[num_cmd].name, cmd, MAX_CMD_LEN);
	all_commands[num_cmd].func = func;
	num_cmd++;
}

void doNoArgvCmd(const char* argv, void(*func)())
{
	if (*argv)
	{
		puts("Invalid operand ");
		puts(argv);
		putch('\r');
	}
	else
	{
		func();
	}
}

void _list()
{
	for (int i = 0; i < num_program; ++i)
	{
		puts(all_programs[i].name);
		putch(' ');
	}
	putch('\r');
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
	_shutdown();
}

void _help()
{
	puts("ls             list all files in current work directory\r");
	puts("info <file>    print detailed infomation of <file>\r");
	puts("clear          clear window\r");
	puts("./ <file>      run <file>--a program\r");
	puts("shutdown       power off\r");
	puts("help           see these tips\r");
	puts("use tab to enjoy complement!\r");
}

void help(const char* argv)
{
	doNoArgvCmd(argv, _help);
}

void visitProgram(const char* argv, void(*visit)(const Program*))
{
	if (*argv == 0)
	{
		puts("Need input file.\r");
	}
	else
	{
		Program* program = getProgram(argv);
		if (program == 0)
		{
			puts("can not find file ");
			puts(argv);
			putch('\r');
		}
		else
		{
			visit(program);
		}
	}
}

void printProgramInfo(const Program* program)
{
	puts("Name: ");
	puts(program->name);
	putch('\r');

	char str[10] = {0};
	char* s[] = {"Bytes", "Cylinder", "Track", "Sector"};
	int infos[] = {program->sector.bytes, program->sector.cylinder, program->sector.track, program->sector.index};
	int n = sizeof(infos) / sizeof(*infos);
	for (int i = 0; i < n; ++i)
	{
		puts(s[i]);
		puts(":  ");
		itos(infos[i], str);
		puts(str);
		putch('\r');
		memset(str, sizeof(str) * sizeof(char), 0);
	}
}

void RunProgram(const Program* program)
{
	int length = numSectors(program->sector.bytes);
	Load(program->sector.cylinder, program->sector.track, program->sector.index, length, program->sector.load_addr);
	resetInt(8);
	setInt9h();
	// cls();
	Run(program->sector.load_addr);
	// cls();
	resetInt(9);
	setInt8h();
}

void info(const char* argv)
{
	visitProgram(argv, printProgramInfo);
}

void run(const char* argv)
{
	visitProgram(argv, RunProgram);
}

#endif // COMMAND_H
