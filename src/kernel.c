#include <stdint.h>
#include "kernel.h"

#define VGA_ADDR	0xB8000
#define MAX_WIDTH	80
#define MAX_HEIGHT	50

uint16_t *video_mem = 0;

uint16_t getLength(const char* str)
{
	uint16_t start=0;
	while(str[start] != '\0')
		start++;
	return start;
}
uint16_t format_char(char c, char color)
{
	return (color << 8 | c);
}
void print_char(const char c, uint16_t color, uint16_t row)
{
	video_mem = (uint16_t *)VGA_ADDR;
	video_mem[row] = format_char(c,color);
}

void print(const char *str, uint16_t color)
{
	uint16_t str_len;
	str_len = getLength(str);
	for(int i=0;i < str_len; i++)
		print_char(str[i], color, i);
}
void clear_screen(void)
{
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
	print("Hello World!", 0x03);
}
