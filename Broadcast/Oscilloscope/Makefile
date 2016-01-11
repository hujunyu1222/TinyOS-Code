COMPONENT=OscilloscopeAppC

#change channel
CC2420_CHANNEL = 13

#cancel ACK
#CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS

#change transmit power
CFLAGS += -DD2420_DEF_REPOWER=31

#change the message_t size
CFLAGS += -D'TOSH_DATA_LENGTH=48'

include $(MAKERULES)
