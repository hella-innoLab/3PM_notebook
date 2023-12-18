#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

for fname in blinds_20deg_BSDF_NY_cie_sun_03211000_5pm blinds_20deg_geom_NY_cie_sun_03211000_5pm; do

  cp ../pts/tutorial_workplane.pts ./t3mp.pts
  fromdos ./t3mp.pts
  tail -n +13 ./${fname}.ill | rlam ./t3mp.pts - > ${fname}_xy.ill
  rm ./t3mp.pts
  
  echo "set terminal png size 1000,1200 font 'Arial,14' " > ${fname}_xy.gnu
  echo "unset key" >> ${fname}_xy.gnu
  echo "set grid" >> ${fname}_xy.gnu
  echo "set xrange [0:5]" >> ${fname}_xy.gnu
  echo "set yrange [0:8]" >> ${fname}_xy.gnu
  echo "set size ratio -1" >> ${fname}_xy.gnu
  echo "set xtics" >> ${fname}_xy.gnu
  echo "set ytics" >> ${fname}_xy.gnu
  echo "set style line 1 lc rgb 'black' lt 1 lw 2" >> ${fname}_xy.gnu
  echo "file = '${fname}_xy.ill' " >> ${fname}_xy.gnu
  echo "set output '${fname}_xy.png' " >> ${fname}_xy.gnu
  echo "set palette model RGB defined ( 0 'red', 400 'magenta', 800 'blue', 1200 'cyan', 1600 'green', 2000 'yellow') " >> ${fname}_xy.gnu
  echo "set cbtics scale default 0,200,2000" >> ${fname}_xy.gnu
  echo "set cbrange [0:2000]" >> ${fname}_xy.gnu
  echo "set cblabel 'Illuminance [lx]' " >> ${fname}_xy.gnu
  echo "plot file using 1:2:7 with points pt 7 ps 7 palette, file using 1:2:(sprintf(\"%.0f\", \$7)) with labels notitle " >> ${fname}_xy.gnu
  
  gnuplot ${fname}_xy.gnu

done