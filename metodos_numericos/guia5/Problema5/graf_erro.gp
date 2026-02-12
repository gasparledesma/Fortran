set styl data lines

set xlabel "n"
set xzeroaxis

#set key bottom left

# ##################################################################################################

###################################          Grafico de abs  de errores relativos  #######################


f(x) = 0.1 * x**(-2)

g(x) = 0.02 * x**(-4)


set terminal wxt size 800, 600 enhanced font ' Helvetica, 12 ' persist

set title "Error en las integrales de  f(t) = exp(-t) con # de puntos nnp 10*2**i+1  "

set ylabel "abs de errores relativos "

set logscale y
set logscale x

#set yrange [-0.002:0.035]


plot 'datossal/prob4PuntoMediofexp.datos' u 1:3 w p t " error punto medio", \
     'datossal/prob4Trapezoidalfexp.datos'   u 1:3 w p t " error trapecio ", \
     'datossal/prob4Simponfexp.datos'  u 1:3 w p t " error Simpson", f(x) t " beta -2", g(x) t   " beta -4"

# set terminal pdf enhanced font ' Helvetica ,4 '
# set output "grafs/p1.pdf "


set terminal png enhanced size 900 ,675

set output "grafs/p5-exp-error-int.png"

replot

exit



