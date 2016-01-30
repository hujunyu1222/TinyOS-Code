COMPONENT=RssiToSerialC
BUILD_EXTRA_DEPS = RssiSerialMsg.java SpecAnalyzer.class
CLEAN_EXTRA = *.class RssiSerialMsg.java

RssiSerialMsg.java: RssiToSerial.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RssiSerialMsg RssiToSerial.h rssi_serial_msg -o $@

SpecAnalyzer.class: $(wildcard *.java) SpecAnalyzer.java
	javac *.java

#change sense channel   11~26
CC2420_CHANNEL=18 

#change the transmit power
#CFLAGS += -DD2420_DEF_REPOWER=10

#change the message_t size
#CFLAGS += -D'TOSH_DATA_LENGTH=48'



include $(MAKERULES)

