COMPONENT=SenderAppC



#change sense channel   11~26
#channel 12: do not use CII
#channel 13: use CII
CC2420_CHANNEL=13 

#change the transmit power
CFLAGS += -DD2420_DEF_REPOWER=10

#change the message_t size
CFLAGS += -D'TOSH_DATA_LENGTH=90'



include $(MAKERULES)

