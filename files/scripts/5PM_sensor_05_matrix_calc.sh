#!/bin/bash

#
# calculation of 5-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#


#############################################

printf "\n 5PM matrix hourly calculation \n"

weather=NY_sky_day01
var=blinds_20deg

printf " 3PM ... \n"
printf " (already done ...) \n"
# time dctimestep matrices/tutorial_room_3pm_sensors.vmx \
#          BSDF/${var}_Klems.xml \
#          matrices/tutorial_room_3pm_rein1.dmx \
#          weather/${weather}.smx \
#          > result/${var}_${weather}_3pm.dat
# rmtxop -fa -c 47.448 119.951 11.601 -t result/${var}_${weather}_3pm.dat \
#         > result/${var}_${weather}_3pm.ill

printf " 3PM direct component ... \n"
time dctimestep matrices/tutorial_room_5pm_sensors.dvmx \
         BSDF/${var}_Klems.xml \
         matrices/tutorial_room_5pm_rein1.ddmx \
         weather/${weather}_direct.smx \
         > result/${var}_${weather}_3pm_dir.dat

for sys in blinds_20deg_BSDF blinds_20deg_geom ; do

  printf " 5PM high qual direct component for ${sys}... \n"
  dctimestep matrices/tutorial_room_5pm_sensors_${sys}.dsmx \
             weather/${weather}_direct_sun.smx \
             > result/${sys}_${weather}_5pm_dir_sun.dat
  printf " calc (3PM - 3PM_dir + 5PM_dir) ... \n"
  rmtxop result/${var}_${weather}_3pm.dat + -s -1 result/${var}_${weather}_3pm_dir.dat + result/${sys}_${weather}_5pm_dir_sun.dat | \
         rmtxop -fa -c 47.448 119.951 11.601 -t - \
         > result/${sys}_${weather}_5pm.ill

done

printf " ... done.\n"

#############################################

printf "\n 5PM matrix point-in-time calculation \n"

weather=NY_cie_sun_03211000
var=blinds_20deg

printf " 3PM ... \n"
printf " (already done ...) \n"
# time dctimestep matrices/tutorial_room_3pm_sensors.vmx \
#          BSDF/${var}_Klems.xml \
#          matrices/tutorial_room_3pm_rein1.dmx \
#          weather/${weather}.smx \
#          > result/${var}_${weather}_3pm.dat
# rmtxop -fa -c 47.448 119.951 11.601 -t result/${var}_${weather}_3pm.dat \
#         > result/${var}_${weather}_3pm.ill

printf " 3PM direct component ... \n"
time dctimestep matrices/tutorial_room_5pm_sensors.dvmx \
         BSDF/${var}_Klems.xml \
         matrices/tutorial_room_5pm_rein1.ddmx \
         weather/${weather}_direct.skyvec \
         > result/${var}_${weather}_3pm_dir.dat

for sys in blinds_20deg_BSDF blinds_20deg_geom ; do

  printf " 5PM high qual direct component for ${sys}... \n"
  dctimestep matrices/tutorial_room_5pm_sensors_${sys}.dsmx \
             weather/${weather}_direct_sun.skyvec \
             > result/${sys}_${weather}_5pm_dir_sun.dat
  printf " calc (3PM - 3PM_dir + 5PM_dir) ... \n"
  rmtxop result/${var}_${weather}_3pm.dat + -s -1 result/${var}_${weather}_3pm_dir.dat + result/${sys}_${weather}_5pm_dir_sun.dat | \
         rmtxop -fa -c 47.448 119.951 11.601 - \
         > result/${sys}_${weather}_5pm.ill

done

printf " ... done.\n"
