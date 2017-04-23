#/***********************************
# *		COPYRIGHT NOTICE
# *		Copyright (c) 2015
# *		All rights reservered
# * 						
# *		@author			:Junyu Hu	hujunyu1222@gmail.com
# *		@file			:/home/hujunyu/Desktop/dealDataWithPython/Rssi_Background/getDecimalRssi.py
# *		@date			:2015-12-08 10:06
# *							
# *		@discription	: convert hexadecimal rssi value into decimal (maxRssi & avgRssi)
# *							
# ***********************************/

import sys;
import string;

TIME = 0;

def process(outfile, line):
		global TIME;
		maxRssi = line[-7:-5];
		avgRssi = line[-13:-11];
		numMax = int(maxRssi, 16) - 127 - 45;
		numAvg = int(avgRssi, 16) - 127 - 45;

		outfile.write(str(TIME)+ " " + str(numMax) + " " + str(numAvg) + "\n");
		TIME += 1;


infilePath = sys.argv[1];
outfilePath = sys.argv[2];

infile = open(infilePath);
outfile = open(outfilePath,'w');

while True:
	line = infile.readline();
	if not line: break;
	process(outfile, line);

infile.close();
outfile.close();


