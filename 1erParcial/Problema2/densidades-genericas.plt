reset
set term wxt persist size 900,600 font "Sans,10"
set encoding utf8
set title "Comparación de LDOS en distintos sitios"
set xlabel "Energía (E)"
set ylabel "LDOS"
set grid

# Leyenda automática
set key autotitle columnheader

# Rango
set xrange [-3:3]
set yrange [0:1.2]

### RUTA DE SALIDA DEL PDF ---
# Guardamos en la carpeta graficos
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/LDOS_sitios_generico.pdf"

### RUTA DE LECTURA DE DATOS ---
# Leemos desde la carpeta datos
plot for [i=2:*] "datos/ldos_genericos.dat" using 1:i with lines lw 2

# Cerramos el PDF
unset output