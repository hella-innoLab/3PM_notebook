#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

#############################################


sky_subdiv=1
# use 4 (i.e. misc/sky_glow1_rein4.rad) for a more detailed description of the sky
mf_sun_pos=2
# use 6 for a more accurate description of the sun positions


###########################################

printf " Direct sky matrix generation ... \n"
# Point in time direct sky vector
xform sky/NY_cie_sun_03211000.rad  | genskyvec -d -m ${sky_subdiv} > weather/NY_cie_sun_03211000_direct.skyvec

printf " Sun matrix generation ... \n"
# Point in time sun matrix
xform sky/NY_cie_sun_03211000.rad  | genskyvec -5 -d -m ${mf_sun_pos} > weather/NY_cie_sun_03211000_direct_sun.skyvec

###########################################

printf " Direct sky matrix generation ... \n"
# generate direct sky matrix
gendaymtx -d -m ${sky_subdiv} weather/NY_sky_day01.wea > weather/NY_sky_day01_direct.smx

printf " Sun matrix generation ... \n"
# generate direct sun matrix
gendaymtx -5 0.5 -d -m ${mf_sun_pos} weather/NY_sky_day01.wea > weather/NY_sky_day01_direct_sun.smx

printf " ... done.\n"
