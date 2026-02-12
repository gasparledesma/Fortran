####################    Mapa de Cruces Evitados (x vs w^2)   ####################
reset
set term wxt persist size 700,600 font "Sans,10"
set title "Cruces Evitados: Densidad de Estados Total"
set xlabel 'Desintonía x (w_2^2 - w_1^2)'
set ylabel 'Frecuencia Cuadrada w^2'
set cblabel '{/Symbol r}_{total}'

# Configuración del mapa de calor (PM3D)
set pm3d map
set palette rgbformulae 33,13,10  # Colores tipo arcoíris/calor
set samples 100    # Resolución en x
set isosamples 100 # Resolución en y (w^2)

# Rangos
set xrange [-2:2]  # Rango de desintonía x (alrededor de 0)
set yrange [4:11]  # Rango de frecuencias w^2
set zrange [0:5]   # Recorte de altura para mejor contraste

#### PARÁMETROS #######
i = {0.0, 1.0}
pi = 3.1415926535

# Valores fijos
w1 = 6.0
wi = 9.0
V = 1.0
eta = 0.1

# Acoplamientos (simétricos)
V1i = V
Vi2 = V
Vi1 = V
V2i = V


# Definimos la posición del nivel 2 en función de la desintonía x
pos_w2(x_desintonia) = w1 + x_desintonia

# Funciones de Green dependientes de (w_sq, x_param)
# w_sq es la variable de energía (y en el plot)
# x_param es la desintonía (x en el plot)

# G11: 1 -> i -> 2
G11(w_sq, x_param) = 1.0 / (w_sq - w1 + i*eta - (V1i*Vi1 / (w_sq - wi + i*eta - (V2i*Vi2 / (w_sq - pos_w2(x_param) + i*eta)))))

# Gii: i conectado a 1 y 2
Gii(w_sq, x_param) = 1.0 / (w_sq - wi + i*eta - (Vi1*V1i / (w_sq - w1 + i*eta)) - (Vi2*V2i / (w_sq - pos_w2(x_param) + i*eta)))

# G22: 2 -> i -> 1
G22(w_sq, x_param) = 1.0 / (w_sq - pos_w2(x_param) + i*eta - (V2i*Vi2 / (w_sq - wi + i*eta - (V1i*Vi1 / (w_sq - w1 + i*eta)))))

# Densidad Total
rho_tot(x_gnuplot, y_gnuplot) = (-1.0/pi) * imag( G11(y_gnuplot, x_gnuplot) + Gii(y_gnuplot, x_gnuplot) + G22(y_gnuplot, x_gnuplot) )

# GRAFICAR
# splot usa x para el primer rango y y para el segundo
splot rho_tot(x, y) title ""

###################################  Exportar a PDF ##########################
set terminal pdfcairo enhanced font 'Sans,12' size 6in,5in
set output "mapa_cruces_evitados.pdf"
replot
unset output