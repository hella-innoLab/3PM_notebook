#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

fname=blinds_20deg_NY_sky_day01
for var in blinds_20deg_BSDF blinds_20deg_geom; do
  phisto ${fname}_*_${var}.hdr > ${fname}_${var}.hist

  for hdr in ${fname}_*_${var}.hdr; do
    hdrname=$( basename ${hdr} .hdr )
    pcond -I -s -c ${hdr} < ${fname}_${var}.hist > ${hdrname}_tonemap.hdr
  done

  convert -delay 100 -loop 0 ${fname}_*_${var}_tonemap.hdr ${fname}_${var}.gif
done

rm *_tonemap.hdr