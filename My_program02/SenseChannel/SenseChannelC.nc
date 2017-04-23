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
	interface Packet;

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
	/******** Declare Tasks  *************/
	task void uartSendTask();
	task void readRssi();
	task void sendSerialMsg();

	static void startTimer();
	static void fatal_problem();
	static void report_problem();
	static void report_sent();
	static void report_received();

	uint8_t uartlen;
	message_t uartbuf;
	
	bool uartbusy=FALSE;
	bool locked = FALSE;
	
	uint8_t rssReading = 0;	/* 0 to RSSIREADINGS */
	channelRssi_t local;


	/********** Boot Events **********/
	//On bootup, initailization radio and serial communication, and our own
	//state variables.
	event void Boot.booted() {
		local.id = TOS_NODE_ID;
		uartlen = sizeof(local);
		rssReading = 0;
		locked = FALSE;
		
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
		//if (call Timer0.isRunning()) call Timer0.stop();
		
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
		post readRssi();	
	}
	
	event void ReadRssi.readDone(error_t error, uint16_t data) {
		
		if (error != SUCCESS){
			post readRssi();
			return;
		}
		
		local.regRssi = data;
		call Leds.led0Toggle();
		post sendSerialMsg();
		/*
		if (rssReading < RSSIREADINGS)
		{
			call Leds.led1Toggle();
			local.regRssi[rssReading++] = data;
		}
		else
		{
			rssReading = 0;
			call SerialSend.send(0x1818, &local, sizeof(local));
		}
		*/
		//startTimer();
	}

	event void SerialSend.sendDone(message_t *msg, error_t error) {
			if (&uartbuf == msg){
				locked = FALSE;
			}
	
	}

	/************ TASKS ***************/
	task void readRssi(){
		if (call ReadRssi.read() != SUCCESS){
			post readRssi();
		}
	}

	task void sendSerialMsg(){
		if (locked){
			return;
		}
		else{

			channelRssi_t *cr = (channelRssi_t*)call Packet.getPayload(&uartbuf, sizeof(channelRssi_t));

			if (call Packet.maxPayloadLength() < sizeof(channelRssi_t)){
				return;
			}

			cr->regRssi = local.regRssi;

			if (call SerialSend.send(0x1234, &uartbuf, sizeof(channelRssi_t)) == SUCCESS ) {
				locked = TRUE;
			}
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
