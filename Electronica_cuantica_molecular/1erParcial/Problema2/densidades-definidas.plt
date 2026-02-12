reset
set term wxt persist size 900,600
set encoding utf8
set title "Evolución de la LDOS desde la Superficie al Interior"
set xlabel "Energía (E)"
set ylabel "LDOS"
set grid

# Estilos
set style line 1 lc rgb "black" lw 2      # Sitio 0 (Superficie)
set style line 2 lc rgb "red" lw 1.5      # Sitio 1
set style line 3 lc rgb "blue" lw 1.5     # Sitio 2
set style line 4 lc rgb "gray" dt 2 lw 3  # Infinita (Referencia)

set yrange [0:1.0]
set xrange [-2.5:2.5]


### Guardamos en la carpeta graficos
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/LDOS_sitios_definidos.pdf"

plot "datos/ldos_definidos.dat" u 1:5 w l ls 4 title "Cadena Infinita (Referencia)", \
     "datos/ldos_definidos.dat" u 1:2 w l ls 1 title "Sitio 0 (Superficie)", \
     "datos/ldos_definidos.dat" u 1:3 w l ls 2 title "Sitio 1", \
     "datos/ldos_definidos.dat" u 1:4 w l ls 3 title "Sitio 2"

# Cerramos el PDF
unset output