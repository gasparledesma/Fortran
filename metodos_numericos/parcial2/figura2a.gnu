set term x11 persist  

set title 'comportamiento de la gota'
set xlabel 'Time (seconds)'                  
set ylabel 'Z_i (meters)'
set samples 600
set key top right
set grid
        
plot "datos/datos.dat" using 1:2 

set terminal pdf enhanced font 'Helvetica,10'
set output "graficos/p2-funciones.pdf"

replot