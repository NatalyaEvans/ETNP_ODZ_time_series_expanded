# -*- coding: utf-8 -*-
"""
Created on Thu Jan 13 07:17:55 2022

@author: Natalya Evans

Purpose: plot a map of stations
"""
#%% Initialize packages


#%matplotlib inline
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
import pandas as pd
import netCDF4
import scipy
from scipy import interpolate

#%% set up map boundaries and graphical properties

def format_string(lonlat): #to remove the +/= and degree marks on ticks when drawing parallels and meridians
    if(lonlat>180):
       return "{num}".format(num=lonlat-360)
    return "{num}".format(num=lonlat)

Nedge=30
Sedge=10
Wedge=-120
Eedge=-100

longlineE=Eedge
longlineW=Wedge
longlinespacing=5

latlineN=Nedge
latlineS=15
latlinespacing=5

markers=["o","^","s","d","P","p","x","o"]
colors = plt.rcParams['axes.prop_cycle'].by_key()['color'] # extracts the default color cycle
colors[3], colors[4]=colors[4], colors[3]

#%% load in data to plot

df = pd.read_csv ('All 8 Cruises_adjusted_omp_KM_uncorrected.csv')
years=['1972','1994','2007','2012','2016SKQ','2016','2018','2019']

#%% Process data to plot
df2 = df[['Cruise', 'long', 'lat']].copy()
df2['lat']=round(df2['lat'],3) # coverts everything to 3 decimal places
cruise_names=df2['Cruise'].unique() # extracts the specific cruise names for a loop later
lat=df2['lat']
long=df2['long']
Cruise=df2['Cruise']

#%% Read in the O2 data

file2read = netCDF4.Dataset('data-set4.nc','r')
print(file2read)
print(file2read.variables.keys())

x = np.array(file2read.variables["Longitude"][:]) # var can be 'defined by he file2read variable keys.
y = np.array(file2read.variables["Latitude"][:]) # var can be 'defined by he file2read variable keys.
Density = np.array(file2read.variables["Density"][:]) # var can be 'defined by he file2read variable keys.
fODZ = np.array(file2read.variables["fODZ"][:]) # var can be 'defined by he file2read variable keys.
fODZ_slice=fODZ[12,:,:]
X, Y = np.meshgrid(x, y) # mesh the x and y

#%% Plot the map with the previous settings

fig = plt.figure(figsize=(8, 8))
plt.rcParams["font.family"] = "sans"
m = Basemap(projection='cyl', resolution='i',
            llcrnrlat=Sedge, urcrnrlat=Nedge,
            llcrnrlon=Wedge, urcrnrlon=Eedge, )
m.shadedrelief(scale=0.2, alpha=0.5)
m.drawcoastlines()
m.drawparallels(np.arange(latlineS,latlineN,latlinespacing),labels=[1,0,0,0], fontsize=11, labelstyle= "+/-", fmt=format_string)
m.drawmeridians(np.arange(longlineW,longlineE,longlinespacing),labels=[1,1,0,1], fontsize=11, labelstyle= "+/-", fmt=format_string)

clev = np.arange(0,1,0.01) #Adjust the .001 to get finer gradient
C=plt.contourf(X,Y,fODZ_slice,clev,cmap='Blues_r',)
cbar = plt.colorbar(shrink = 0.825,)
#cbar = plt.colorbar(shrink = 0.45,)
cbar.ax.set_ylabel('ODZ fraction at 26.5 kg $m^{-3}$')

for i in range(len(cruise_names)): #goes through each cruise
    plt.plot(long[Cruise==cruise_names[i]],lat[Cruise==cruise_names[i]],linestyle='None',marker=markers[i],label=years[i],color=colors[i])

# Pescadero
plt.plot(-(108+(11.79/60)),24+(16.88/60),linestyle='None',marker='*',color='m',markersize=10,label='Pescadero\nBasin')

plt.xlabel('Longitude/°E', labelpad=20, fontsize=11)
plt.ylabel('Latitude/°N', labelpad=35, fontsize=11)
plt.legend()
plt.savefig('transect-map-O2.tif', dpi=900, format=None)

