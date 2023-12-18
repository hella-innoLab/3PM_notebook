#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

#############################################

printf " 3PM matrix calculation... \n"

for var in blinds_20deg ; do

  printf " annual calculation... (only one day) \n"
  weather=NY_sky_day01
  time dctimestep matrices/tutorial_room_3pm_sensors.vmx \
           BSDF/${var}_Klems.xml \
           matrices/tutorial_room_3pm_rein1.dmx \
           weather/${weather}.smx \
           > result/${var}_${weather}_3pm.dat
  rmtxop -fa -c 47.448 119.951 11.601 -t result/${var}_${weather}_3pm.dat \
          > result/${var}_${weather}_3pm.ill


  weather=NY_cie_sun_03211000
  printf " point in time calculation... \n"
  time dctimestep matrices/tutorial_room_3pm_sensors.vmx \
           BSDF/${var}_Klems.xml \
           matrices/tutorial_room_3pm_rein1.dmx \
           weather/${weather}.skyvec \
           > result/${var}_${weather}_3pm.dat
  rmtxop -fa -c 47.448 119.951 11.601 result/${var}_${weather}_3pm.dat \
          > result/${var}_${weather}_3pm.ill

done

printf " ... done.\n"
