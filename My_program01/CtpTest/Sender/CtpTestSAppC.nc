configuration CtpTestSAppC{}

implementation
{
	components MainC, CtpTestSC, LedsC, new TimerMilliC();

	CtpTestSC.Boot -> MainC;
	CtpTestSC.Timer -> TimerMilliC;
	CtpTestSC.Leds -> Leds;

	//CTP Protocal
	components  CollectionC as Collector,
		ActiveMessageC, new CollectionSenderC(AM_OSCILLOSCOPE); //def AM_OSCILLOSCOPE in .h
	
	CtpTestSC.RadioControl -> ActiveMessageC;
	CtpTestSC.RoutingControl -> Collector;
	CtpTestSC.Send -> CollectionSenderC;
	CtpTestSC.Receive -> Collector.Receive(AM_OSCILLOSCOPE);
	CtpTestSC.RootControl -> Collector;
}
