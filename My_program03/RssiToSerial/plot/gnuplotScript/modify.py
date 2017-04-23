#***********************************
#*		COPYRIGHT NOTICE
#*		Copyright (c) 2015
#*		All rights reservered
#* 						
#*		@author			:Junyu Hu	hujunyu1222@gmail.com
#*		@file			:/home/hujunyu/Desktop/TinyOS Code/My_program03/RssiToSerial/plot/gnuplotScript/modify.py
#*		@date			:2016-01-30 10:50
#*							
#*		@discription	:	
#*							
#***********************************/
import sys;
import string;

def process(outfile,line):
	line = line.split();
	index = int(line[0]);
	index = index * 0.128;
	
	outfile.write(str(index)+" " + line[1] + " " + line[2] + "\n");

infilePath = sys.argv[1];
outfilePath = sys.argv[2];

infile = open(infilePath);
outfile = open(outfilePath, 'w');

while True:
	line = infile.readline();
	if not line: break;
	process(outfile, line);

infile.close();
outfile.close();
