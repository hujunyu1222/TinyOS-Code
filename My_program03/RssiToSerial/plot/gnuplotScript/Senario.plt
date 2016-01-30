#

set term post eps color
set output outfile

set xlabel "Time (ms)"
set xtics 2

set ylabel "RSSI (dBm)"
set yrange [-95:-40]

#set title "RSSI of channel 12"
set arrow from 0,-60 to 16,-60 nohead lt 3 lw 2

plot infile using 1:2 every ::1::120 with linespoints title "RSSI"
