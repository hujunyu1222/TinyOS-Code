/*
 * Use the ZigBee nodes to sense the Channel Power
 *
 * @author Junyu Hu
 */

configuration SenseChannelAppC { }
implementation {
	components MainC, SenseChannelC, LedsC, new TimerMilliC(),
		new DemoSensorC() as Sensor;
	
	//MainC.SoftwareInit -> Sensor;
	SenseChannelC.Boot -> MainC;
	SenseChannelC.Leds -> LedsC;
	SenseChannelC.Timer0 -> TimerMilliC;	

	//Timer:AlarmMicro16C();
//	components new AlarmMicro16C();

//	SenseChannelC.Alarm0 -> AlarmMicro16C;

	//Read the RSSI register
	components CC2420ControlC as RssiReader;
	SenseChannelC.ReadRssi -> RssiReader.ReadRssi;

	//Serial Commucation
	components ActiveMessageC,				//AM layer
	SerialActiveMessageC,					//Serial messaging
	new SerialAMSenderC(AM_OSCILLOSCOPE);	//Sends to the serial port
	
	SenseChannelC.RadioControl -> ActiveMessageC;
	SenseChannelC.SerialControl -> SerialActiveMessageC;
	SenseChannelC.SerialSend -> SerialAMSenderC.AMSend;
	SenseChannelC.Packet -> SerialActiveMessageC;

	components new PoolC(message_t, 10) as UARTMessagePoolP,
	  new QueueC(message_t*, 10) as UARTQueueP;

	SenseChannelC.UARTMessagePool -> UARTMessagePoolP;
	SenseChannelC.UARTQueue -> UARTQueueP;

	/*
	components new PoolC(message_t, 20) as DebugMessagePool,
		new QueueC(message_t*, 20) as DebugSendQueue,
		new SerialAMSenderC(AM_CTP_DEBUG) as DebugSerialSender,
		UARTDebugSenderP as DebugSender;

	DebugSender.Boot -> MainC;
	DebugSender.UARTSend -> DebugSerialSender;
	DebugSender.MessagePool -> DebugMessagePool;
	DebugSender.SendQueue -> DebugSendQueue;
	*/
	

}
