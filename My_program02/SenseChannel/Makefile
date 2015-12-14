COMPONENT=SenseChannelAppC
CFLAGS += -I$(TOSDIR)/lib/net/ -I$(TOSDIR)/lib/net/ctp -I$(TOSDIR)/lib/net/4bitle

#change the message_t size
CFLAGS +=-D'TOSH_DATA_LENGTH=48'

#change channel
CFLAGS += -DCC2420_DEF_CHANNEL=25

include $(MAKERULES)
