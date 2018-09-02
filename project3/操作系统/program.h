#ifndef PROGRAM_H
#define PROGRAM_H
#include "../include/string.h"

typedef struct Program {
	char name[21];
	int cylinder;
	int track;
	int start_sector;
	int bytes;
	int loadAddr;
} Program;

Program all_programs[5];
int num_program = 0;

void addProgram(const char* program, int startAddr, int endAddr, int loadAddr)
{
	Program* newProgram = all_programs + num_program;
	num_program++;
	strncpy(newProgram->name, program, 20);
	newProgram->bytes = endAddr - startAddr + 1;
	int sector = startAddr / 0x200;			//物理扇区号
	int y = sector / 18;
	newProgram->cylinder = (y >> 1);
	newProgram->track = (y & 1);
	int z = sector % 18;
	newProgram->start_sector = z + 1;
	newProgram->loadAddr = loadAddr;
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
