set terminal png size 1000,1200 font 'Arial,14' 
unset key
set grid
set xrange [0:5]
set yrange [0:8]
set size ratio -1
set xtics
set ytics
set style line 1 lc rgb 'black' lt 1 lw 2
file = 'blinds_20deg_geom_NY_cie_sun_03211000_5pm_xy.ill' 
set output 'blinds_20deg_geom_NY_cie_sun_03211000_5pm_xy.png' 
set palette model RGB defined ( 0 'red', 400 'magenta', 800 'blue', 1200 'cyan', 1600 'green', 2000 'yellow') 
set cbtics scale default 0,200,2000
set cbrange [0:2000]
set cblabel 'Illuminance [lx]' 
plot file using 1:2:7 with points pt 7 ps 7 palette, file using 1:2:(sprintf("%.0f", $7)) with labels notitle 
