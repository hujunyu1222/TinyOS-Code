#ifdef _CTPTEST_H
#define _CTPTEST_H

enum
{
	AM_OSCILLOSCOPE = 0x93
};

typedef nx_struct oscilloscope {
	nx_uint16_t nodeId;
	nx_uint16_t counter;
}oscilloscope_t;

#endif
