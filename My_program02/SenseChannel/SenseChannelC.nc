/***********************************
 *		COPYRIGHT NOTICE
 *		Copyright (c) 2015
 *		All rights reservered
 * 						
 *		@author			:Junyu Hu	hujunyu1222@gmail.com
 *		@file			:/home/hujunyu/Desktop/TinyOS Code/My_program02/SenseChannel/SenseChannelC.nc
 *		@date			:2015-11-12 09:45
 *							
 *		@discription	:	
 *							
 ***********************************/

#include "Timer.h"
#include "SenseChannel.h"

module SenseChannelC @safe(){
	uses {
	// Interface for initialization:
	interface Boot;
	interface SplitControl as RadioControl;
	interface SplitControl as SerialControl;

	// Interface for communication, multihop and serial:
	interface AMSend as SerialSend;

	interface Queue<message_t *> as UARTQueue;
	interface Pool<message_t> as UARTMessagePool;

	// Timer
	interface Timer<TMilli> as Timer0;

//	// Alarm
//	interface Alarm<TMicro,uint16_t> as Alarm0;
	
	interface Leds;

	// Interface CC2420Register as ReadRssi;
	interface Read<uint16_t> as ReadRssi;
	}
}

implementation {
	task void uartSendTask();
	static void startTimer();
	static void fatal_problem();
	static void report_problem();
	static void report_sent();
	static void report_received();

	uint8_t uartlen;
	message_t uartbuf;
	
	bool uartbusy=FALSE;
	
	uint8_t rssReading = 0;	/* 0 to RSSIREADINGS */
	channelRssi_t local;

	//On bootup, initailization radio and serial communication, and our own
	//state variables.
	event void Boot.booted() {
		local.id = TOS_NODE_ID;
		uartlen = sizeof(local);
		
	//Beginning our initialization phases:
	if (call RadioControl.start() != SUCCESS)
		fatal_problem();

	}
	
	event void RadioControl.startDone(error_t error) {
		if (error != SUCCESS)
			fatal_problem();
		
		if (call SerialControl.start() != SUCCESS)
			fatal_problem();
		
		
	}
	
	event void SerialControl.startDone(error_t error) {
		if (error != SUCCESS)
			fatal_problem();

		startTimer();
	}
	
	static void startTimer() {
		if (call Timer0.isRunning()) call Timer0.stop();
		
		call Timer0.startPeriodic(100);	
	}	


	event void RadioControl.stopDone(error_t error) { }
	event void SerialControl.stopDone(error_t error) { }

	task void uartSendTask() {
		if (call SerialSend.send(0x1919, &uartbuf, uartlen) != SUCCESS) {
			report_problem();
		} else {
			uartbusy = TRUE;
		}
	}
	
	event void Timer0.fired() {
		call ReadRssi.read();	
	}
	
	event void ReadRssi.readDone(error_t error, uint16_t data) {
		
		call Leds.led0On();
		if (rssReading < RSSIREADINGS)
		{
			local.regRssi[rssReading++] = data;
		}
		else
		{
			rssReading = 0;
			call SerialSend.send(0x1818, &local, sizeof(local));
		}
		//startTimer();
	}

	event void SerialSend.sendDone(message_t *msg, error_t error) {
		uartbusy = FALSE;
		if (call UARTQueue.empty() == FALSE) {
			message_t * queuemsg = call UARTQueue.dequeue();
			
			if (queuemsg == NULL) {
				fatal_problem();
				return;
			}
			memcpy(&uartbuf, queuemsg, sizeof(message_t));
			if (call UARTMessagePool.put(queuemsg) != SUCCESS) {
				fatal_problem();
				return;
			}
			post uartSendTask();
		}
	}

	static void fatal_problem() {
		call Leds.led0On();
		call Leds.led1On();
		call Leds.led2On();
		//call Alarm0.stop();
	}
	
	static void report_problem() { call Leds.led0Toggle(); }
	static void report_sent() { call Leds.led1Toggle(); }
	static void report_received() { call Leds.led2Toggle(); }

}
