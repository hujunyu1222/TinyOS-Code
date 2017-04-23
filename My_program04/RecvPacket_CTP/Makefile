COMPONENT=MultihopOscilloscopeAppC
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp  -I$(TOSDIR)/lib/net/4bitle

#change channel
CC2420_CHANNEL=18

#change the message_t size
CFLAGS += -D'TOSH_DATA_LENGTH=48'

#cancel ACK
CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS

#change the transmit power: max 31
#CFLAGS += -DCC2420_DEF_POWER = 31
include $(MAKERULES)
