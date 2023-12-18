#!/bin/bash

#
# calculation of 3-Phase-Method for Test Room
# Bartenbach GmbH, Rinner Str. 14, 6071 Aldrans, Austria
# 07.08.2019 / DGM
#

#############################################

printf " Sky matrix generation ... \n"

sky_subdiv=1
# use 4 (i.e. misc/sky_glow1_rein4.rad) for a more detailed description of the sky


# Point in time sky vector
xform sky/NY_cie_sun_03211000.rad  | genskyvec -m ${sky_subdiv} > weather/NY_cie_sun_03211000.skyvec

# convert EPW file to wea
epw2wea weather/USA_NY_New.York-Central.Park.725033_TMY3.epw weather/NY_sky.wea

# select only first day to show...
head -n 30 weather/NY_sky.wea > weather/NY_sky_day01.wea

# generate annual sky matrix (here only one day)
gendaymtx -m ${sky_subdiv} weather/NY_sky_day01.wea > weather/NY_sky_day01.smx

printf " ... done.\n"
