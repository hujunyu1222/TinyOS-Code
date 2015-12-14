#!/bin/sh
#

java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB0:telosb > ./0.txt &
java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB1:telosb > ./1.txt &

