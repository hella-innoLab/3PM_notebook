#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

fname=blinds_20deg_NY_sky_day01
phisto ${fname}_*.hdr > ${fname}.hist

for hdr in ${fname}_*.hdr; do
  hdrname=$( basename ${hdr} .hdr )
  pcond -I -s -c ${hdr} < ${fname}.hist > ${hdrname}_tonemap.hdr
done

convert -delay 100 -loop 0 ${fname}_*_tonemap.hdr ${fname}.gif

rm *_tonemap.hdr