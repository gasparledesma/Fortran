set term x11 persist  

set title 'Coordenadas de Diferencia'
set xlabel 'Time (seconds)'                  
set ylabel 'Displacement (meters)'
set samples 600
set xrange [0:5]
set key top right
set grid
        
plot "datos/p2-funciones.dat" using 1:4 with lines

set terminal pdf enhanced font 'Helvetica,10'
set output "graficos/p2-deltaX.pdf"

replot