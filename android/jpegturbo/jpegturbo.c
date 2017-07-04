#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "./libjpeg-turbo/turbojpeg.h"

typedef unsigned long  DWORD;


void read_head(char * buf,int size){
	int n;
	int pos = 0;
	for(;;) {
		n = read(STDIN_FILENO, buf + pos, size-pos);
		if(n<0){
			printf("Read Head Error:%i\n",n);
			exit(1);
		}else if(n == 0) {
			printf("Read Head End:%i\n",n);
			exit(1);
		}else {
			pos += n;
			if(pos == size){
				break;
			}
		}
	}
}

void make_scale(int scale,DWORD *p_width,DWORD *p_height,char *read_buf) {
	int i,j;
	int w,h;
	DWORD * p_dw_buf = (DWORD *)read_buf;
	switch(scale){
		case 2:
		case 4:
		case 8:
			// 只支持2,4,8倍缩小
			w = (*p_width) /scale;
			h = (*p_height) / scale;
			(*p_width) = w;
			(*p_height) = h;
			for(j = 0; j<h; j++) {
				for(i = 0; i<w; i++) {					
					p_dw_buf[j * w + i] = p_dw_buf[j*scale*w*scale + (i*scale)];
				}
			}
			break;
	}
}

int main(int argc,char * argv[]) {
	void * tj_handle; 

	char *read_buf = NULL;
	int read_buf_size;
	int read_buf_pos;

	DWORD head[3];
	DWORD width,height;

	int n;
	int ret;
	unsigned char * jpeg_buf = NULL;
	unsigned long jpeg_size=0;

	int scale = 1;
	int quality =90;

	// 检查参数：
	// jpegturbo 缩小倍数(2,4,8) 品质
	if(argc != 3) {
		printf("using: jpegturbo scale quality");
		exit(1);
	}
	scale = atoi(argv[1]);
	quality = atoi(argv[2]);


	tj_handle = tjInitCompress();
	
	read_head((char *)head,3*sizeof(DWORD));

	width = head[0];
	height = head[1];

	read_buf_size = width*height*4;
	read_buf = malloc(read_buf_size+64*1024);
	read_buf_pos = 0;

	while(1) {
		n = read(STDIN_FILENO, read_buf + read_buf_pos, 64*1024);
		if(n<0) {
		    perror("read STDIN_FILE ERROR\n");
		    exit(1);
		} else if(n == 0) {
			break;
		} else {
			read_buf_pos += n;
			if(read_buf_pos > read_buf_size){
			    perror("read STDIN_FILE SIZE ERROR\n");
			    exit(1);				
			}
		}
	}

	if(read_buf_pos != width*height*4){
	    perror("Size Error\n");
	    exit(1);
	}

	make_scale(scale,&width, &height, read_buf);

	ret = tjCompress2( tj_handle, read_buf,
		width, width * 4, height, 
		TJPF_RGBX, &jpeg_buf, &jpeg_size, 
		TJSAMP_420 , quality,TJFLAG_FASTDCT);

	if(ret < 0 ) {
	    perror("make jpeg Error\n");		
	    exit(1);
	}

	free(read_buf);

	write(STDOUT_FILENO, jpeg_buf, jpeg_size);

}