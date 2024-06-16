
import pandas as pd
# convert epw file to wea file 
# extract normal direct radiation and diffuse horizontal radiation from epw file
def epw2wea(epw_file, file_out):
    epw_data = pd.read_csv(epw_file, header=None, skiprows=8)
    
    with open(epw_file,"r") as file:
        line_temp = file.readline()
    line_split = line_temp.split(",")
    
    month = epw_data[1].values
    day = epw_data[2].values
    hour = epw_data[3].values
    dir_nor_rad = epw_data[14].values
    diff_hor_rad = epw_data[15].values
    
    site_elevation = line_split[-1].split('\n')[0]
    #TODO: hard coded for IBK
    time_zone = -15
    
    header = ""
    header += f"place {line_split[1]}_{line_split[3]}\n"
    header += f"latitude {line_split[6]}\n"
    header += f"longitude {-(float(line_split[7]))}\n"
    header += f"time_zone {time_zone}\n" 
    header += f"site_elevation {site_elevation}\n"
    header += f"weather_data_file_units 1\n"

    with open(file_out, 'w') as file:
        file.write(header)
        for m, d, h, dnr, dhr in zip(month, day, hour, dir_nor_rad, diff_hor_rad):
            file.write(f'{m} {d} {h-0.5} {dnr} {dhr}\n')