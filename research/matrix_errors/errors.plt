#f(x) = a*x**b
f(x) = a/x
#g(x) = c*x**d
g(x) = c/(x*x)

fit [10:800] f(x) 'relative_error{frob}.dat' using 1:2 via a
fit [10:800] g(x) 'error{frob}.dat' using 1:2 via c

set logscale cb
set cbrange[1:2]
set terminal latex
set logscale
set xlabel "Sample size $n$"
set ylabel "Error"
set title "Asymptotic covariance error vs sample size"
set output "fig_frob_error_3_expo.tex"
	 
plot [10:800] [0.00028:2.8] 'error{frob}.dat' using 1:2 title "Absolute Error" with points, \
	 f(x) notitle with lines, \
	 'relative_error{frob}.dat' using 1:2 title "Relative Error" with points, \
	 g(x) notitle with lines
			  
#'error{frob}.dat' using 1:2 smooth bezier notitle with lines, \			  
#'relative_error{frob}.dat' using 1:2 smooth bezier notitle with lines