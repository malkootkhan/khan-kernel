#include <stdint.h>
#include "kernel.h"

#define VGA_ADDR	(0xB8000)
#define MAX_WIDTH	(80)
#define MAX_HEIGHT	(50)


enum color {BLACK, READ, WHITE, GREEN};

uint16_t *video_mem = 0;

struct position 
{
	uint16_t x;
	uint16_t y;
};
struct position pos;

uint16_t getLength(const char* str)
{
	uint16_t start=0;
	while(str[start] != '\0')
		start++;
	return start;
}
uint16_t format_char(char c, char color)
{
	return (GREEN << 8 | c);
}
void print_char(const char c, const uint16_t color)
{

	video_mem = (uint16_t *)VGA_ADDR;
	video_mem[pos.y * MAX_WIDTH + pos.x] = format_char(c,color);
	pos.x += 1;
	if(pos.x == MAX_WIDTH)
	{
		pos.x = 0;
		pos.y += 1;
	}
	if(pos.y == MAX_HEIGHT)
	{
		pos.y = 0;
		pos.x = 0;
	}
}

void print(const char *str)
{
	uint16_t str_len;
	str_len = getLength(str);
	for(int i = 0; i < str_len; i++)
		print_char(str[i], GREEN);
}
void clear_screen(void)
{
	pos.x = 0;
	pos.y = 0;
	video_mem = (uint16_t *)VGA_ADDR;
	for(int y = 0; y < MAX_HEIGHT; y++)
	{
		for(int x = 0; x < MAX_WIDTH; x++)
		{
			video_mem[y*MAX_HEIGHT + x] = format_char(' ', 0); // 0 for black color
		}
	}
}

void kernel_main()
{
	clear_screen();
	print("The first sentence!");
	print("The second sentence!");
	print("The three sentence!");
	print("The fourth sentence!");
}






