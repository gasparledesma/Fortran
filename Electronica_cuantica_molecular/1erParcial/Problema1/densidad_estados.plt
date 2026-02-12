####################    Grafico cruces evitados

set term wxt persist
set title "Densidad de Estados - Cadena 1-i-2"
set ylabel '{/Symbol r}(w^2)'
set xlabel 'w^2'


set samples 2000
set xrange [4.5:10.5]
#set yrange [-1:5]




    #### FORMULA  #######
    i = sqrt(-1)
    # Posiciones de los niveles (equispaciados)
    ε_1 = 6
    ε_2 = ε_1 + 0.5
    ε_i = 9
    
    # Acoplamientos iguales
        V = 1.0
        V1i = V
        Vi2 = V
        Vi1 = V
        V2i = V
    
    # Anchos iguales
    η_1 = 0.1
    η_2 = 0.1
    η_i = 0.1


    ##### formula exacta

    G_11 (x) = 1/((x-ε_1+i*η_1-V1i*Vi1/(x-ε_i+i*η_i-V2i*Vi2/(x-ε_2+i*η_2))))

    G_ii (x) = 1/((x-ε_i+i*η_i-(V1i*Vi1/(x-ε_1+i*η_1))-(V2i*Vi2/(x-ε_2+i*η_2))))

    G_22 (x) = 1/((x-ε_2+i*η_2-V2i*Vi2/(x-ε_i+i*η_i-V1i*Vi1/(x-ε_1+i*η_1))))

    ##### Tomando un valor medio en la parte imaginaria

    #G_11 (x) = 1/((x-ε_1+i*η_1-V12*V21/(x-ε_2+i*η_2-V23*V32/(x-ε_3+i*η_3))))

    r_1(x) = (-1/pi)*imag(G_11(x))
    r_2 (x) = (-1/pi)*imag(G_22(x))
    r_i (x) = (-1/pi)*imag(G_ii(x))
    r_t (x) = r_1(x)+r_2(x)

    plot r_1(x) title "{/Symbol r}_1_1" lc rgb "red" with lines, \
         r_i(x) title "{/Symbol r}_i_i" lc rgb "blue" with lines, \
         r_2(x) title "{/Symbol r}_2_2" lc rgb "green" with lines, \
         r_t(x) title "{/Symbol r}_1_+_2" lc rgb "black"  dt 2 lw 1

###################################  export as pdf gnuplot ##########################
set terminal pdfcairo enhanced font 'Sans,12'

set output "grafico_de_densidad_estados.pdf"

    plot r_1(x) title "{/Symbol r}_1_1" lc rgb "red" with lines, \
         r_i(x) title "{/Symbol r}_i_i" lc rgb "blue" with lines, \
         r_2(x) title "{/Symbol r}_2_2" lc rgb "green" with lines, \
         r_t(x) title "{/Symbol r}_1_+_2" lc rgb "black" dt 2 lw 1

unset output  # Cierra el archivo

exit
