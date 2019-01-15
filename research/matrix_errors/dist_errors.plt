f(x) = a*x**b
fit [60:3000] f(x) 'dist.dat' using 1:(abs(.95-$9)) via a,b

set logscale cb
set cbrange[1:2]
set terminal gif
#set logscale
set xlabel "Sample size $n$"
set ylabel "Error"
set title "This vs sample size"
set output "fig_3_expo.gif"
	 
#plot [10:100] [0.8:.95] 'dist.dat' using 1:2 title "AbsErrTrueAsym" with points, \
#	'dist.dat' using 1:3 title "RelErrTrueAsym" with points, \
#	'dist.dat' using 1:4 title "AbsErrMu" with points, \
#	'dist.dat' using 1:6 title "RelErrMu" with points, \
#	'dist.dat' using 1:8 title "CRegionTrue" with points, \
#	'dist.dat' using 1:9 title "CRegionMle" with points

plot [10:3000] 'dist.dat' using 1:(abs(.95 - $9)) title "P(true in ellipsoid)" with points, \
	f(x) notitle with lines 
