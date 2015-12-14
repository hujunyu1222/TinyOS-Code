#!/bin/sh

java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB$1:telos
