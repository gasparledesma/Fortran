
set styl data lines

set xlabel "n"
set xzeroaxis
set key bottom left

# ##########################

set terminal wxt size 800 ,600 enhanced font ' Helvetica ,12 ' persist

set title "Integrales usando los tres métodos de f(x) = 2/(x-4) con n hasta 100 "   

set ylabel " integrales "

#set logscale x
#set logscale y

fName1 = "./datossal/prob4PuntoMediofHip.datos"
fName2 = "./datossal/prob4TrapezoidalfHip.datos"
fName3 = "./datossal/prob4SimponfHip.datos"

#set xrange [1e-30:1.0]
 set yrange [-0.26717:-0.26695]

plot fName1 u 1:2 w p t " punto medio", \
     fName2 u 1:2 w p t " trapecio ", \
     fName3 u 1:2 w p t " Simpson"

# set terminal pdf enhanced font ' Helvetica ,4 '
# set output "grafs/p1.pdf "
set terminal png enhanced size 900 ,675

set output "grafs/p4-hip-integ.png"

replot

# #################################################################################

set terminal wxt size 800 ,600 enhanced font ' Helvetica ,12 ' persist

set title "Error en las integrales de  f(x) = 2/(x-4) con n hasta 100 "

set ylabel "errores"
set yrange [-0.0001:0.0002] 

fName1 = "./datossal/prob4PuntoMediofHip.datos"
fName2 = "./datossal/prob4TrapezoidalfHip.datos"
fName3 = "./datossal/prob4SimponfHip.datos"


plot fName1 u 1:3 w p t " punto medio", \
     fName2 u 1:3 w p t " trapecio ", \
     fName3 u 1:3 w p t " Simpson"

# set terminal pdf enhanced font ' Helvetica ,4 '
# set output "grafs/p1.pdf "


set terminal png enhanced size 900 ,675

set output "grafs/p4-hip-erro-int.png"

replot

exit

