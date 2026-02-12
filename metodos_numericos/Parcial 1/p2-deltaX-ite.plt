set term x11 persist  

set title 'Cordenadas de Diferencia (por iteraciones)'
set xlabel 'Iteraciones'                  
set ylabel 'DeltaX (meters)'
set samples 600
set xrange [1:30]
set key top right
set grid
        
plot "datos/biseccion.dat" using 1:2 with lines

set terminal pdf enhanced font 'Helvetica,10'
set output "graficos/p2-deltaX-ite.pdf"

replot