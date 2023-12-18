#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

#############################################

printf " 3PM matrix calculation... \n"

for var in blinds_20deg ; do

  printf " annual calculation... (actually only one day) \n"
  weather=NY_sky_day01
  time dctimestep -o result/img_3pm/${var}_${weather}_%04d.hdr \
          matrices/img_vmx/tutorial_room_%03d.hdr \
          BSDF/${var}_Klems.xml \
          matrices/tutorial_room_3pm_rein1.dmx \
          weather/${weather}.smx

  printf " point in time calculation... \n"
  weather=NY_cie_sun_03211000
  time dctimestep -o result/img_3pm/${var}_${weather}_%04d.hdr \
          matrices/img_vmx/tutorial_room_%03d.hdr \
          BSDF/${var}_Klems.xml \
          matrices/tutorial_room_3pm_rein1.dmx \
          weather/${weather}.skyvec
done

printf " ... done.\n"
