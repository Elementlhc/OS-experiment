#ifndef CTYPE_H
#define CTYPE_H

int isalpha(char c)
{
	return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z';
}

int isdigit(char c)
{
	return c >= '0' && c <= '9';
}

int isspace(char c)
{
	return c == '\r' || c == '\t' || c == ' ' || c == '\n';
}

#endif // CTYPE_H
