#include "Timer.h"
#include "CtpTest.h"


module CtpTestSC
{
  uses
  {
  	interface Boot;
	interface SplitControl as RadioControl;
	interface StdControl as Routing;
	interface Send;
	interface Receive;
	interface RootControl;
	interface Timer<TMilli>;
	interface Leds;
  }

}

implementation
{
	static void startTimer();
	static void fatal_problem();

	message_t packet;
	bool sendbusy = FALSE;

	//local state
	oscilloscope_t local;

	event void Boot.booted() {

	local.nodeId = TOS_NODE_ID;
	local.counter = 0xABCD;

	if (call RadioControl.start() != SUCCESS)
		fatal_problem();

	if (call RoutingControl.start() != SUCCESS)
		fatal_problem();
	}

	event void RadioControl.startDone(error_t error) {
	 if (error != SUCCESS)
	 	fatal_problem();

	 if (sizeof(local) > call Send.maxPayloadLength())
	 	fatal_problem();
	
	 /*
	  **
	 //set root
	 if (local.nodeId == 0)
	  call RootControl.setRoot();
	 */

	 startTimer();
	}

	event void Timer.fired()
	{
		oscilloscope_t *o = (oscilloscope_t)call getPayload(&packet, sizeof(oscilloscope_t));
		if (o == NULL){
		  fatal_problem();
		  return;
		}
		memcpy(o, &local, sizeof(oscilloscope_t));
	
	//send packet
	if (call Send.send(&packet, sizeof(oscilloscope_t)) == SUCCESS)
	{	
		sendbusy = TRUE;
		call Leds.led2Toggle();
	}

	}
	
	event void Send.sendDone(message_t* msg, error_t error)
	{
		sendbusy = FALSE;
		call Leds.led2Toggle();
	}



	static void startTimer() {
	 if (call Timer.isRunning()) call Timer.stop();
	 call Timer.startPeriodic(2000);
	}

	static void fatal_problem() {
	  call Leds.led0On();
	  call Leds.led1On();
	  call Leds.led2On();
	  call Timer.stop();
	}






}
