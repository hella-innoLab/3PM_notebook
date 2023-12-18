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
#   printf " annual calculation... (actually only one day) \n"
#   weather=NY_sky_day01
#   time dctimestep -o result/img_3pm/${var}_${weather}_%04d.hdr \
#           matrices/img_vmx/tutorial_room_%03d.hdr \
#           BSDF/${var}_Klems.xml \
#           matrices/tutorial_room_3pm_rein1.dmx \
#           weather/${weather}.smx

printf " 3PM direct component ... \n"
time dctimestep -o result/img_3pm_dir/${var}_${weather}_%04d.hdr \
        matrices/img_vmx_dir_lum/tutorial_room_%03d_lum.hdr \
        BSDF/${var}_Klems.xml \
        matrices/tutorial_room_5pm_rein1.ddmx \
        weather/${weather}_direct.smx

for sys in blinds_20deg_BSDF blinds_20deg_geom ; do

  printf " 5PM high qual direct sun component for ${sys}... \n"
  dctimestep -o result/img_5pm_dir_sun/${var}_${weather}_%04d_${sys}.hdr \
              matrices/img_vmx_sun_all/tutorial_room_${sys}_%04d.hdr \
              weather/${weather}_direct_sun.smx

  printf " calc (3PM - 3PM_dir + 5PM_sun) ... \n"
  for img in result/img_3pm/${var}_${weather}_????.hdr; do
    img_b=$(basename ${img} .hdr)
    pcomb -h -e 'ro=ri(1)-ri(2)+ri(3);go=gi(1)-gi(2)+gi(3);bo=bi(1)-bi(2)+bi(3)' \
    -o ${img} -o result/img_3pm_dir/${img_b}.hdr -o result/img_5pm_dir_sun/${img_b}_${sys}.hdr \
    > result/img_5pm/${img_b}_${sys}.hdr
  done

done

printf " ... done.\n"

#############################################

printf "\n 5PM matrix point-in-time calculation \n"

weather=NY_cie_sun_03211000
var=blinds_20deg

printf " 3PM ... \n"
printf " (already done ...) \n"
#   printf " annual calculation... (actually only one day) \n"
#   weather=NY_sky_day01
#   time dctimestep -o result/img_3pm/${var}_${weather}_%04d.hdr \
#           matrices/img_vmx/tutorial_room_%03d.hdr \
#           BSDF/${var}_Klems.xml \
#           matrices/tutorial_room_3pm_rein1.dmx \
#           weather/${weather}.skyvec

printf " 3PM direct component ... \n"
time dctimestep -o result/img_3pm_dir/${var}_${weather}_%04d.hdr \
        matrices/img_vmx_dir_lum/tutorial_room_%03d_lum.hdr \
        BSDF/${var}_Klems.xml \
        matrices/tutorial_room_5pm_rein1.ddmx \
        weather/${weather}_direct.skyvec

for sys in blinds_20deg_BSDF blinds_20deg_geom ; do

  printf " 5PM high qual direct sun component for ${sys}... \n"
  dctimestep -o result/img_5pm_dir_sun/${var}_${weather}_%04d_${sys}.hdr \
              matrices/img_vmx_sun_all/tutorial_room_${sys}_%04d.hdr \
              weather/${weather}_direct_sun.skyvec


  printf " calc (3PM - 3PM_dir + 5PM_sun) ... \n"
  for img in result/img_3pm/${var}_${weather}_????.hdr; do
    img_b=$(basename ${img} .hdr)
    pcomb -h -e 'ro=ri(1)-ri(2)+ri(3);go=gi(1)-gi(2)+gi(3);bo=bi(1)-bi(2)+bi(3)' \
    -o ${img} -o result/img_3pm_dir/${img_b}.hdr -o result/img_5pm_dir_sun/${img_b}_${sys}.hdr \
    > result/img_5pm/${img_b}_${sys}.hdr
  done

done

printf " ... done.\n"
