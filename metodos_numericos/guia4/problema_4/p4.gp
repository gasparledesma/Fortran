
set styl data lines

set  xlabel "t"
set  ylabel "observaciones" 
set  xzeroaxis
set  key bottom left

# #######################################################################

set terminal wxt size 1050 ,750 enhanced font ' Helvetica ,12 ' persist
set title " Datos originales "
plot 'pos.dat' u 1:2 w p t " datos "
#set terminal pngcairo enhanced size 900 ,600
#set output "grafs/p4-datos.png"

set terminal postscript colour                   ########   postscript
set output "grafs/p4-datos.eps"

replot

# ###############################################################

set terminal wxt 2 size 1050 ,750 enhanced font ' Helvetica ,12 ' persist

set title "Derivadas"
set xlabel "t"
set ylabel "derivadas"

plot 'datos/p4-d1o2.dat' u 1:2 w p t " Derivada 1 o2 " , 'datos/p4-d1o4.dat' u 1:2 w p t " Derivada 1 o4 "          


#set terminal pngcairo enhanced size 900, 600
#set output "grafs/p4-derivadas.png"

set terminal postscript colour                   ########   postscript
set output "grafs/p4-derivadas.eps"

replot


exit


