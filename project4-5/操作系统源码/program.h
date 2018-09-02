#ifndef PROGRAM_H
#define PROGRAM_H
#include "../include/string.h"
#include "sector.h"

typedef struct Program {
	char name[21];
	Sector sector;
} Program;

Program all_programs[10];
int num_program = 0;

void addProgram(const char* program, int start_addr, int end_addr, int load_addr)
{
	Program* newProgram = all_programs + num_program;
	num_program++;
	strncpy(newProgram->name, program, 20);
	sectorInit(&(newProgram->sector), start_addr, end_addr, load_addr);
}

Program* getProgram(const char* process_name)
{
	for (int i = 0; i < num_program; ++i)
	{
		if (strcmp(all_programs[i].name, process_name) == 0)
		{
			return all_programs + i;
		}
	}
	return 0;
}

#endif // PROGRAM_H
