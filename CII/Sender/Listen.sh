#!/bin/sh
# $1 is the Serial Port
java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB$1:telos
