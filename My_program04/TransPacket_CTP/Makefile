COMPONENT=MultihopOscilloscopeAppC
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp  -I$(TOSDIR)/lib/net/4bitle

#change channel 11~26
CC2420_CHANNEL=25

#change the transmission power 1~31
CFLAGS += -DD2420_DEF_REPOWER=10

#change the message_t size
#CFLAGS += -D'TOSH_DATA_LENGTH=48'

#cancel ACK
CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS



include $(MAKERULES)
