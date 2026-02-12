reset
set term wxt persist size 800,600  
set encoding utf8

set title "estados resonantes y Regla de oro de Fermy"
set grid
set xlabel "Energía (E)"
set ylabel "Amplitud"

# Definir colores y estilos
set style line 1 lc rgb "red" lw 2      
set style line 2 lc rgb "green" lw 2    
set style line 3 lc rgb "blue" lw 2     
set style line 4 lc rgb "orange" dt 2   

# Rango
set xrange [-5:5]

### RUTA DE SALIDA DEL PDF ---
# Guardamos en la carpeta graficos
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/probabilidad_ldos.pdf"

### RUTA DE LECTURA DE DATOS ---
set xrange [0:5]
plot "datos/comparacion_probabilidad.dat" u 1:2 w l ls 1 title "cadena de 1 rama inf", \
     "datos/comparacion_probabilidad.dat" u 1:3 w l ls 3 title "cadena de 2 rama inf", \
     
set xrange [5:5]     
plot "datos/comparacion_ldos.dat" u 1:2 w l ls 1 title "cadena de 1 rama inf",/
     "datos/comparacion_ldos.dat" u 1:3 w l ls 3 title "cadena de 2 rama inf",/

     
     
# Cerramos el PDF
unset output