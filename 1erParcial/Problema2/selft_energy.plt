reset
set term wxt persist size 800,600  
set encoding utf8

set title "Comparación de Ramas de Self-Energy"
set grid
set xlabel "Energía (E)"
set ylabel "Amplitud"

# Definir colores y estilos
set style line 1 lc rgb "red" lw 2      # Gamma
set style line 2 lc rgb "green" lw 2    # Delta
set style line 3 lc rgb "blue" lw 2     # Real Part (Correcta)
set style line 4 lc rgb "orange" dt 2   # Ramas descartadas (opcional)

# Rango
set xrange [-3:3]
set yrange [-1.5:1.5]

# Graficamos
# u 1:2 -> Gamma función (Linea Roja)
# u 1:3 -> Gamma complejo (Puntos) -> Deben caer sobre la linea roja
# u 1:4 -> Delta (Linea Verde)
# u 1:5 -> Real Part Final (Linea Azul - Lógica combinada)

# Si quiere ver que el metodo A y B en la parte imaginaria sacar el # de u 1:3 w 

### RUTA DE SALIDA DEL PDF ---
# Guardamos en la carpeta graficos
set terminal pdfcairo enhanced font 'Sans,12' size 6in,4in
set output "graficos/sigma-real-img.pdf"

### RUTA DE LECTURA DE DATOS ---

plot "datos/datos_sigma.dat" u 1:2 w l ls 1 title "Gamma (Función)", \
     "datos/datos_sigma.dat" u 1:5 w l ls 3 title "Re[Sigma]"

# Descomenta la siguiente linea si quieres ver por qué descartamos las otras ramas:
#replot "datos/datos_sigma.dat" u 1:3 w p pt 7 ps 0.5 lc rgb "black" title "Gamma (Check aimag)", \
     "datos/datos_sigma.dat" u 1:4 w l ls 2 title "Delta (Recta)"
     
     
# Cerramos el PDF
unset output