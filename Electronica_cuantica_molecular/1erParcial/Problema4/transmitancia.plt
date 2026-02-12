reset
set term wxt persist size 700,600 font "Sans,10"

set xlabel "Energía (E)"
set ylabel "Transmisión T(E)"
set grid

# Leyenda automática
set key autotitle columnheader

# Rango
set xrange [-3:3]
#set yrange [0:1.2]

plot "datos/transmitancia.dat" using 1:2 with lines lw 2 title "V_L=0.3V ; V_R = 0.5 V"

###################################  Exportar a PDF ##########################
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/transmitancia.pdf"
replot
unset output

unset output