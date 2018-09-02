extern void printCharAt(int, int, char, short);

#define MAX_ROW 25
#define MAX_COL 80

typedef enum Direction {
	LEFT = -1, 
	RIGHT = 1,
	UP = -1,
	DOWN = 1,
	NONE = 0
}Direction;

void Move(int* row, int* col, Direction* hori, Direction* verti)
{
	if (*row == 0)
	{
		if (*col == 0)
		{
			*hori = NONE;
			*verti = DOWN;
		}
		else if (*col == MAX_COL - 1)
		{
			*hori = LEFT;
			*verti = NONE;
		}
	}
	else if (*row == MAX_ROW -  1)
	{
		if (*col == 0)
		{
			*hori = RIGHT;
			*verti = NONE;
		}
		else if (*col == MAX_COL - 1)
		{
			*hori = NONE;
			*verti = UP;
		}
	}
	*row = (*row + *verti) % MAX_ROW;
	*col = (*col + *hori) % MAX_COL;
}

int row1, row2, col1, col2;

Direction h1 = NONE, h2 = NONE;
Direction v1 = NONE, v2 = NONE;
int index = 0;

// 解决全局变量初始化不正确的问题
int flag = 0;
void init()
{
	row1 = col1 = row2 = 0;
	col2 = MAX_COL - 1;
	flag = 1;
}

void cTimer()
{
	if(!flag)	init();
	printCharAt(row1, col1, 'A' + index, (row1 - index + 1) * MAX_ROW + col1);
	printCharAt(row2, col2, ' ', 0x07);

	Move(&row1, &col1, &h1, &v1);
	Move(&row2, &col2, &h2, &v2);

	if (row1 == 0 && col1 == 0)
	{
		index = (index + 1) % 26;
	}
}