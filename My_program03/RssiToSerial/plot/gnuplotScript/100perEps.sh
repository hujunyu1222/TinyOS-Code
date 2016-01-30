#
for i in 'seq 100'
gnuplot -e "infile = '../Rssi_2symbolTime_dec.txt'; outfile =$i; begin=$i*100; end=($i+1)*100;" 2symbolTime.plt
done
