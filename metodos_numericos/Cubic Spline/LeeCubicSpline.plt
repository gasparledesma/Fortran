 reset
# set border 31 lt -1 lw 1.000
# set style data lines
# este comando grafica lineas en lugar de cruces
#

set macros
# set style data linespoints
set style data points
set pointsize 0.2
# set style data lines
#
#
#  Poner aqui el nombre del archivo de datos
 set terminal postscript eps size 15.0cm, 15.0cm enhanced color font 'Helvetica,26' linewidth 4
 
#
#
# este comando grafica puntos unidos por lineas
#
# Sobre el eje x
#set xlabel 'Energy [keV]' offset 0, 0.5
#set xrange [1.84:1.90]
set grid xtics
#set xtics nomirror
#
#
# Sobre el eje Y
# set logscale y
#set ylabel 'Efficiency [a.u.]' offset 1.8, 0
#set yrange [00:0.08]
set grid ytics
#set ytics nomirror
#
#
#Sobre el eje x2
#set x2label 'Up Energy [keV]' offset 0, -0.5
#set x2range [100:2600]
#set grid x2tics
# set x2tics
#
#
# label1 = 'Graph 1,   left side'
#
#
#
#
# Sobre el eje Y2
# set y2label 'Right   Efficiency [%  a.u.]' offset -0.8, 0
# set y2range [00:0.04]
# set grid y2tics
# set y2tics
#
#
#
#
# label2 = 'Graph 2, right side'# 
#
#
# set border 3
#
# griega {/Symbol a}
# griega = 'a' # font "Symbol, 16"'
# Ti = 'HPGe' # font "Times Roman Bold, 16"
# TiT = #Ti font "Times Roman Bold, 16"
# Tle = 'Efficiency font "Times Roman Bold, 16"
# set title = Ti+griega+Tle offset 0, 0
# set title Ti
#
# set title 'HPGe $griega Efficiency' font "Times Roman Bold, 16"  offset 0, 0
# set border 3
# set title 'HPGe  Efficiency' font "Symbol, 16"  offset 0, 0
#      Arial#      Arial Italic
#      Arial Bold
#      Arial Bold Italic
#      Times Roman
#      Times Roman Italic
#      Times Roman Bold
#      Times Roman Bold Italic
#      Helvetica
#      Roman
#
#

#
# set output 'Eficiencias_Ge.ps'
# set terminal postscript
#
# set output 'Eficiencias_Ge5.jpg'
# set terminal jpeg size 600, 400
# set terminal jpeg
#
# plot "datafile.1" with lines, "datafile.2" with points
#

#set xrange [-0.2:2.2]
#set yrange [-0.2:1.2]

#File_name = 'TCM11-45-4Hs-B.Spe'
#set output  'TCM11-2.eps'
esc = 1.0

# File_name = 'TMC11-45-24-Hs.Spe'
File_name_In  = 'datosIn_b.dat'
File_name_Out = 'datosOut_b.dat'

# set output  'TMC11-45-24-Hs.eps'
set output 'datosInter.eps'

#esc = 0.5

plot File_name_In u 1:2 w p ps 2 lc rgb "red" title File_name_In, \
     File_name_Out u 1:2 w l lc rgb "blue" title File_name_Out     


exit
