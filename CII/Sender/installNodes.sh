#!/bin/sh

make telosb

make telosb install,$2 bsl,/dev/ttyUSB$1
