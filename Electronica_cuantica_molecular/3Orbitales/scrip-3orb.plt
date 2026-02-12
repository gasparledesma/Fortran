####################    Grafica de 3 orbitales atomicos

set term wxt persist

set ylabel '(1/π)imagG_1_1'
set xlabel 'ε'


set samples 2000
set xrange [0:2.3]
#set yrange [-1:5]




    #### FORMULA  #######
    i = sqrt(-1)
    # Posiciones de los niveles (equispaciados)
    ε_1 = 0.8
    ε_2 = 1.2
    ε_3 = 1.6
    
    # Acoplamientos iguales
    V12 = 0.3
    V23 = 0.3
    V21 = V12
    V32 = V23
    
    # Anchos iguales
    η_1 = 0.14
    η_2 = 0.08
    η_3 = 0.04


    ##### formula exacta

    G_11 (x) = 1/((x-ε_1+i*η_1*x-V12*V21/(x-ε_2+i*η_2*x-V23*V32/(x-ε_3+i*η_3*x))))

    ##### Tomando un valor medio en la parte imaginaria

    #G_11 (x) = 1/((x-ε_1+i*η_1-V12*V21/(x-ε_2+i*η_2-V23*V32/(x-ε_3+i*η_3))))

    plot (-1/pi)*imag(G_11(x)) title "imgG11" lc rgb "red" with lines


###################################  export as pdf gnuplot ##########################
set terminal pdfcairo enhanced font 'Sans,12'

set output "grafico3orb.pdf"

plot (-1/pi)*imag(G_11(x)) title "imgG11" lc rgb "red" with lines

unset output  # Cierra el archivo

exit
