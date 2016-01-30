/***********************************
 *		COPYRIGHT NOTICE
 *		Copyright (c) 2015
 *		All rights reservered
 * 						
 *		@author			:Junyu Hu	hujunyu1222@gmail.com
 *		@file			:/home/hujunyu/Desktop/TinyOS Code/CII/SenderC.nc
 *		@date			:2016-01-04 21:16
 *							
 *		@discription	:	
 *							
 ***********************************/
 
#include "Timer.h"
#include "Sender.h"
 
 /**
  * This is more of a general demonstration than a test.
  *
  * Install this application to one node, connected to the computer.
  * The node will measure the environmental RSSI from the CC2420 and
  * sending those readings over the serial port.
  *
  * Use the Java application to display the relative RSSI readings.
  *
  * @author Jared Hill
 * @date   23 March 2007
  */
 
module SenderC {
  uses {
    interface Leds;
    interface Boot;
    interface AMSend;
    interface SplitControl as AMControl;
    interface SplitControl as SerialControl;
    interface Packet;
    interface Read<uint16_t> as ReadRssi;
    interface CC2420Config as Config;
	//Send Packet
	interface Timer<TMilli> as Timer0;
	interface AMSend as PacketSender;
  }
}
implementation {

  /******* Global Variables ****************/
  message_t packet;
  bool locked;
  uint32_t total;
  uint16_t largest;
  uint16_t reads;
  //threshold RSSI & CII
  uint16_t threshold;
  uint16_t count;
  uint32_t cii;
  uint32_t ciiThreshold;
  //Send Packet
  message_t sendBuf;
  bool sendBusy;
  oscilloscope_t local;
 
  /******** Declare Tasks *******************/
  task void readRssi();
  task void sendSerialMsg();

  /******** Declare Report Problem *******************/
  void report_problem();
  void report_sent();
  void clear();
  void sendPacket();
  /******** Start Timer *******************/
  void startTimer();

  /************ Boot Events *****************/
  event void Boot.booted() {
    call AMControl.start();
    total = 0;
    largest = 0;
    reads = 0;
    locked = FALSE;
	//threshold
	threshold = 97;//84等于RSSI的-88dBm
	count = 0;
	cii =0;
	ciiThreshold = 680; //采样时间128 × 128us
	//Send Packet
	local.interval = DEFAULT_INTERVAL;
	local.id = TOS_NODE_ID;
	local.channel = call Config.getChannel(); 
  }

  void startTimer() {
  	call Timer0.startPeriodic(local.interval);
  }

  /************ AMControl Events ******************/
  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      //call SerialControl.start();
	  startTimer();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }
  
  /***************SerialControl Events*****************/
  event void SerialControl.startDone(error_t error){
    if (error == SUCCESS) {
      post readRssi();
    }
    else {
      call AMControl.start();
    }
  }
  
  event void SerialControl.stopDone(error_t error){
    //do nothing
  }
  
  /***************** AMSend Events ****************************/
  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    
    if (&packet == bufPtr) {
      locked = FALSE;
    }
    //post readRssi();
  }
  
  /**************** ReadRssi Events *************************/
  event void ReadRssi.readDone(error_t result, uint16_t val ){
    
    if(result != SUCCESS){
      post readRssi();
      return;
    }
    atomic{
      total += val;
      reads ++;
      if(largest < val){
        largest = val;
      }
	  //cii
	  if(val < threshold){
		count+=1;
		
	  }
	  else{
		cii += count * count;
		count = 0;
	  }
	
    } 
    if(reads == (1<<LOG2SAMPLES)){
   // if(reads == 128){
	  //hjy change
	  cii += count * count;
	  return;
     // post sendSerialMsg();
    }
    
    post readRssi();
    
  }
  
  /********************* Send Packet based on CII *************************/
  /*
	if CII is above the threshold that we defined, the node will send the packet.
	
  */

  event void Timer0.fired() {
	post readRssi();

	if (cii >= ciiThreshold) {
		local.cii = cii;
		sendPacket();
		local.count++;
		clear();
	}
	else {
		clear();
	}
  }

  event void PacketSender.sendDone(message_t* msg, error_t error) {
  if (error == SUCCESS)
	{
		report_sent();
	}
  else
    report_problem();
  
  sendBusy = FALSE;
  }


  /********************* Config Events *************************/
  event void Config.syncDone(error_t error){
  
  }

  void sendPacket(){
	if (!sendBusy && sizeof local <= call PacketSender.maxPayloadLength())
	{
		memcpy(call PacketSender.getPayload(&sendBuf, sizeof(local)), &local, sizeof(local));
		if (call PacketSender.send(AM_BROADCAST_ADDR, &sendBuf, sizeof(local)) == SUCCESS)
		{
			sendBusy = TRUE;
		}
	}
	if (!sendBusy)
	{
		report_problem();
	}
  }
  /***************** TASKS *****************************/  
  task void readRssi(){
   
    if(call ReadRssi.read() != SUCCESS){
      post readRssi();
    }
  }

  
  
  task void sendSerialMsg(){
    if(locked){
      return;
    }
    else {
      rssi_serial_msg_t* rsm = (rssi_serial_msg_t*)call Packet.getPayload(&packet, sizeof(rssi_serial_msg_t));
      
      if (call Packet.maxPayloadLength() < sizeof(rssi_serial_msg_t)) {
	    return;
      }
	  atomic{
	    rsm->rssiAvgValue = (total >> (LOG2SAMPLES));
	    rsm->rssiLargestValue = largest;
		rsm->rssiSequence = cii;
		//
		rsm->test = threshold*2;
		//
	    total = 0;
	    largest = 0;
	    reads = 0;
		cii = 0;
		count = 0;
	  }
	  rsm->channel = call Config.getChannel();
      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(rssi_serial_msg_t)) == SUCCESS) {
	    locked = TRUE;
      }
    }
  }

  /********************* Clear  *************************/
  void clear() {
	total = 0;
	largest = 0;
    reads = 0;
	cii = 0;
	count = 0;
  }


  /*********************Use LEDs to report problem *************************/
  void report_problem() { call Leds.led0Toggle();}
  void report_sent() { call Leds.led1Toggle(); }

}




