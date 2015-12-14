/***********************************
 *		COPYRIGHT NOTICE
 *		Copyright (c) 2015
 *		All rights reservered
 * 						
 *		@author			:Junyu Hu	hujunyu1222@gmail.com
 *		@file			:/home/hujunyu/Desktop/TinyOS Code/My_program02/SenseChannel/SenseChannel.h
 *		@date			:2015-10-28 10:45
 *							
 *		@discription	:	
 *							
 ***********************************/

#ifndef SENSECHANNEL_H
#define SENSECHANNEL_H

enum {
	/* Default sampling period.  */
	RSSIREADINGS = 10,
	
	DEFAULT_INTERVAL = 1024,

	AM_OSCILLOSCOPE = 0x93,
};

typedef nx_struct channelRssi {
	nx_uint16_t version;
	nx_uint16_t interval;
	nx_uint16_t id;
	nx_uint16_t count;
	
	nx_uint16_t regRssi[10];
} channelRssi_t;
#endif
