reset
set term wxt persist size 700,600 font "Sans,10"

set xlabel "Energía (E)"
set ylabel "N(E)"
set grid

# Leyenda automática
set key autotitle columnheader

# Rango
set xrange [-4:4]
#set yrange [0:1.2]

plot "datos/ldos_hofstadter.dat" using 1:2 with lines lw 2 title "Q = 2/(3a) ; W = 0.5v"

###################################  Exportar a PDF ##########################
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/ldos_hofstadter-Q_15-W_05.pdf"
replot
unset output

unset output