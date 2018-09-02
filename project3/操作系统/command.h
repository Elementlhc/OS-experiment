#ifndef COMMAND_H
#define COMMAND_H
#define MAX_CMD_LEN 20
#include "../include/string.h"
#include "../include/stdlib.h"
#include "program.h"

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
		putch('\n');
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
	putch('\n');
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
	puts("ls             list all files in current work directory\n");
	puts("info <file>    print detailed infomation of <file>\n");
	puts("clear          clear window\n");
	puts("./ <file>      run <file>--a program\n");
	puts("shutdown       power off\n");
	puts("help           see these tips\n");
	puts("use tab to enjoy complement!\n");
}

void help(const char* argv)
{
	doNoArgvCmd(argv, _help);
}

void visitProgram(const char* argv, void(*visit)(const Program*))
{
	if (*argv == 0)
	{
		puts("Need input file.\n");
	}
	else
	{
		Program* program = getProgram(argv);
		if (program == 0)
		{
			puts("can not find file ");
			puts(argv);
			putch('\n');
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
	putch('\n');

	char str[10] = {0};
	char* s[] = {"Bytes", "Cylinder", "Track", "Sector"};
	int infos[] = {program->bytes, program->cylinder, program->track, program->start_sector};
	int n = sizeof(infos) / sizeof(*infos);
	for (int i = 0; i < n; ++i)
	{
		puts(s[i]);
		puts(":  ");
		itos(infos[i], str);
		puts(str);
		putch('\n');
		memset(str, sizeof(str) * sizeof(char), 0);
	}
}

void RunProgram(const Program* program)
{
	int size = program->bytes;
	int length = size / 0x200;
	if (size % 0x200)
	{
		length++;
	}
	Load(program->cylinder, program->track, program->start_sector, length, program->loadAddr);
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
