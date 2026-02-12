set styl data lines

set xlabel "n"
#set xzeroaxis
#set key bottom left

# #########################################################################################

############################       GRAFICOS de INTEGRALES    ##############################


set terminal wxt size 800 ,600 enhanced font ' Helvetica ,12 ' persist

set title "Integrales usando los tres métodos de f(t) = exp(-t) con nro puntos nnp 10*2**i+1 "


set ylabel " integrales "

set logscale x
#set logscale y


fName1 = "./datossal/prob4PuntoMediofexp.datos"
fName2 = "./datossal/prob4Trapezoidalfexp.datos"
fName3 = "./datossal/prob4Simponfexp.datos"

# set xrange [1e-30:1.0]
# set yrange [0.6318:0.6323]

plot "./datossal/prob4PuntoMediofexp.datos" u 1:2 w p t " punto medio", \
     "./datossal/prob4Trapezoidalfexp.datos" u 1:2 w p t " trapecio ", \
     "./datossal/prob4Simponfexp.datos" u 1:2 w p t " Simpson"

# set terminal pdf enhanced font ' Helvetica ,4 '
# set output "grafs/p5.pdf "

set terminal png enhanced size 900 ,675

set output "grafs/p5-exp-integ.png"

replot

# #################################################################################


exit


