/***********************************
 *		COPYRIGHT NOTICE
 *		Copyright (c) 2015
 *		All rights reservered
 * 						
 *		@author			:Junyu Hu	hujunyu1222@gmail.com
 *		@file			:/home/hujunyu/Desktop/TinyOS Code/CII/SenderAppC.nc
 *		@date			:2016-01-04 21:06
 *							
 *		@discription	:	
 *							
 ***********************************/

 
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
 
 
configuration SenderAppC {}
implementation {
  components MainC, SenderC as App, LedsC;
  components new TimerMilliC();
  components SerialActiveMessageC as AM;
  components ActiveMessageC;
  components CC2420ControlC;
  
  components new AMSenderC(AM_OSCILLOSCOPE);
  
  App.Boot -> MainC.Boot;
  App.SerialControl -> AM;
  App.AMSend -> AM.AMSend[AM_RSSI_SERIAL_MSG];
  App.AMControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.Packet -> AM;
  App.ReadRssi -> CC2420ControlC.ReadRssi;
  App.Config -> CC2420ControlC.CC2420Config;

  //Send Packet
  App.Timer0 -> TimerMilliC;
  App.PacketSender -> AMSenderC;
}


