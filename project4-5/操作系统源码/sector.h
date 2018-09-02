#ifndef SECTOR_H
#define SECTOR_H

typedef struct Sector
{
	int cylinder;
	int track;
	int index;
	int load_addr;
	int bytes;
}Sector;

void sectorInit(Sector* sector, int start_addr, int end_addr, int load_addr)
{
	int sec = start_addr / 0x200;			//物理扇区号
	int y = sec / 18;
	sector->cylinder = (y >> 1);
	sector->track = (y & 1);
	int z = sec % 18;
	sector->index = z + 1;
	sector->load_addr = load_addr;
	sector->bytes = end_addr - start_addr + 1;
}

int numSectors(int bytes)
{
	int length = bytes / 0x200;
	if (bytes % 0x200)
	{
		length++;
	}
	return length;
}

#endif // SECTOR_H
