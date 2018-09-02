#ifndef STRING_H
#define STRING_H
#include "ctype.h"

int strcmp(const char* a, const char* b)
{
	while(*a && *b && *a == *b) {
	    ++a;
	    ++b;
	}
	return *a - *b;
}

int strlen(const char *s)
{
	const char* tmp = s;
	while(*tmp) {
	    tmp++;
	}
	return tmp - s;
}

void strcpy(char *des, const char *src)
{
	while(*src) {
	    (*des++) = (*src++);
	}
	*des = 0;
}

void strncpy(char *des, const char *src, int n)
{
	while(*src && (n--)) {
	    (*des++) = (*src++);
	}
	*des = 0;
}

int find(const char* s, const char** arr, int len)
{
	for (int i = 0; i < len; ++i)
	{
		if (strcmp(s, arr[i]) == 0)
		{
			return i;
		}
	}
	return -1;
}

int starts_with(const char* str, const char* substr)
{
	while(*str && *substr && *str == *substr) {
	    str++;
	    substr++;
	}
	return *substr == 0;
}

void memset(char* a, int len, char c)
{
	for (int i = 0; i < len; ++i)
	{
		a[i] = c;
	}
}

const char* mismatch(const char* a, const char* b)
{
	while(*a && *b && *a == *b) {
	   ++a;
	   ++b;
	}
	return a;
}

int split(const char* src, char des[][20])
{
	const char *last = src;
	int len = 0;
	while(*src) {
	    if(isspace(*src)) {
	    	if(src != last) {
	    		strncpy(des[len], last, src - last);
	    		len++;
	    	}
	    	last = src + 1;
	    }
	    src++;
	}
	if(src != last) {
		strncpy(des[len], last, src - last);
		len++;
	}
	return len;
}

void reverse(char *s, int b, int e)
{
	--e;
	while(b < e) {
	    char c = s[b];
	    s[b] = s[e];
	    s[e] = c;
	    b++;
	    e--;
	}
}

// 整数转字符串
void itos(int num, char* res)
{
	int i = 0;
	if (num == 0)
	{
		*res = '0';
		i++;
	}
	else
	{
		while(num) {
		    res[i] = '0' + num % 10;
		    num /= 10;
		    i++;
		}
	}
	res[i] = 0;
	reverse(res, 0, i);
}

char* lstrip(char* s)
{
	while(isspace(*s)) {
	    *s++ = 0;
	}
	return s;
}

void rstrip(char* s)
{
	int len = strlen(s);
	while(len-- && isspace(s[len])) {
	    s[len] = 0;
	}
}
#endif // STRING_H
