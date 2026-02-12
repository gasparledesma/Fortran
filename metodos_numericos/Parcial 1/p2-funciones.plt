set term x11 persist  

set title 'Funciones de Movimiento'
set xlabel 'Time (seconds)'                  
set ylabel 'Displacement (meters)'
set samples 600
set xrange [0:5]
set key top right
set grid
        
plot "datos/p2-funciones.dat" using 1:2 with lines
replot "datos/p2-funciones.dat" using 1:3 with lines

set terminal pdf enhanced font 'Helvetica,10'
set output "graficos/p2-funciones.pdf"

replot