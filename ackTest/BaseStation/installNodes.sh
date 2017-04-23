#!/bin/sh

make telosb

make telosb install,$1 bsl,/dev/ttyUSB$2
