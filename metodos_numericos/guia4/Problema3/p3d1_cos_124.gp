
set styl data lines
set xlabel "h"
set ylabel " errores "
set xzeroaxis

# ###################################################################################

set terminal wxt size 800 ,600 enhanced font ' Helvetica ,12 ' persist

set title "Error en la primera derivada orden 2 y 4 de f(x) = cos(x) en x = 2"

set logscale x
set logscale y

fName1 = "./datos/p3-cos-1.dat"
fName2 = "./datos/p3-cos-2.dat"
fName3 = "./datos/p3-cos-3.dat"

set xrange [1e-30:1.0]
# set yrange [1e-27:100000]
plot fName1 u 1:(abs($3)) w p t " error orden o1 1", \
     fName1 u 1:(abs($5)) w p t " error orden o2 1", \
     fName1 u 1:(abs($7)) w p t " error orden o4 1", \
     fName2 u 1:(abs($3)) w p t " error orden o1 2", \
     fName2 u 1:(abs($5)) w p t " error orden o2 2", \
     fName2 u 1:(abs($7)) w p t " error orden o4 2", \
     fName3 u 1:(abs($3)) w p t " error orden o1 3", \
     fName3 u 1:(abs($5)) w p t " error orden o2 3", \
     fName3 u 1:(abs($7)) w p t " error orden o4 3"

 set terminal pdf enhanced font ' Helvetica ,4 '
 set output "grafs/p3d1.pdf "
set terminal png enhanced size 900 ,675

set output "grafs/p3-cos-all.png"

replot

#################################################################################





exit
