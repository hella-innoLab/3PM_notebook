import numpy as np
import matplotlib.pyplot as plt
import os

data_path = os.path.join(os.path.dirname(__file__),'3PM_notebook','files','result','blinds_20deg_NY_sky_day01_3pm_test.ill')

header_n = 12
with open(data_path) as f:
    data = f.readlines()[header_n:]

    
data_matrix = np.vstack([np.array([float(v) for v in d.split()]) for d in data])

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(data_matrix[:,44], label='p44')
ax.plot(data_matrix[:,30], label='p30')
ax.set(xlabel='Time', ylabel='Illuminance in lx')
ax.legend()

x = np.arange(4.1,0.9-.1,-0.4)
y = np.arange(7.25,.95-.1,-0.45)
data_noon = data_matrix[12,:].reshape(9,15)




fig = plt.figure()
ax = fig.add_axes([0.1,0.1,0.5,0.8], aspect='equal')
cax = fig.add_axes([0.6,0.1,0.02,0.8])
cplot = ax.contourf(x,y,data_noon.T, cmap='jet', levels=50)
ax.set(xlabel='x in m', ylabel='x in m')
fig.colorbar(cplot, cax=cax)
cax.set_ylabel('Illuminance in lx')
print(data)