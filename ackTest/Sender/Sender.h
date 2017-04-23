#ifndef RSSI_TO_SERIAL_H
#define RSSI_TO_SERIAL_H

typedef nx_struct rssi_serial_msg {
  nx_uint16_t rssiAvgValue;
  nx_uint16_t rssiLargestValue;
  nx_uint8_t channel;
  //cii
  nx_uint16_t test;
  nx_uint32_t rssiSequence;
} rssi_serial_msg_t;

typedef nx_struct oscilloscope {
	nx_uint16_t version;
	nx_uint16_t interval;
	nx_uint16_t id;
	nx_uint16_t count;
	nx_uint8_t channel;
	nx_uint32_t cii;
	//lqi
	nx_uint8_t lqi;
} oscilloscope_t;

enum {
  AM_RSSI_SERIAL_MSG = 134,
  WAIT_TIME = 256,
  //* Using log2 samples to avoid a divide. Sending a packet every 1 second will allow
  //* allow about 5000 samples. A packet every half second allows for 2500 samples, and
  //* a packet every quarter second allows for 1250 samples. 
    
  // When to send a packet is based upon how many samples have been taken, not a 
  // predetermined amount of time. Rough estimates of time can be found using the 
  // conversion stated above. 
  LOG2SAMPLES = 7,

  //Send Packet
  FAST_INTERVAL =  256,
  SLOW_INTERVAL =  512,

  AM_OSCILLOSCOPE = 0x93
};



#endif
