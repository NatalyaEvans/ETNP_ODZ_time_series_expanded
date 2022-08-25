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
import netCDF4
from sqlalchemy import false


def format_string(lonlat): #to remove the +/= and degree marks on ticks when drawing parallels and meridians
    if(lonlat>180):
       return "{num}".format(num=lonlat-360)
    return "{num}".format(num=lonlat)

#%% set up map boundaries and graphical properties
Nedge=30
Sedge=5
Wedge=-130
Eedge=-85

longlineE=Eedge
longlineW=Wedge
longlinespacing=5

latlineN=Nedge
latlineS=10
latlinespacing=5

markers=["o","^","s","d","P","p","x","o"]
colors = plt.rcParams['axes.prop_cycle'].by_key()['color'] # extracts the default color cycle
colors[3], colors[4]=colors[4], colors[3]

#%% load in data to plot

file2read = netCDF4.Dataset('data-set4.nc','r')
print(file2read)
print(file2read.variables.keys())

x = np.array(file2read.variables["Longitude"][:]) # var can be 'defined by he file2read variable keys.
y = np.array(file2read.variables["Latitude"][:]) # var can be 'defined by he file2read variable keys.

topDensity = np.array(file2read.variables["topDensity"][:]) # var can be 'defined by he file2read variable keys.
botDensity = np.array(file2read.variables["botDensity"][:]) # var can be 'defined by he file2read variable keys.

#%% Plot the map with the previous settings

#Z=(topDepth+botDepth)/2
Z=(topDensity+botDensity)/2


fig = plt.figure(figsize=(8, 8))
plt.rcParams["font.family"] = "sans"
m = Basemap(projection='cyl', resolution='i',
            llcrnrlat=Sedge, urcrnrlat=Nedge,
            llcrnrlon=Wedge, urcrnrlon=Eedge, )
m.shadedrelief(scale=0.2, alpha=0.5)
m.drawcoastlines()
m.drawparallels(np.arange(latlineS,latlineN,latlinespacing),labels=[1,0,0,0], fontsize=11, labelstyle= "+/-", fmt=format_string)
m.drawmeridians(np.arange(longlineW,longlineE,longlinespacing),labels=[1,1,0,1], fontsize=11, labelstyle= "+/-", fmt=format_string)
plt.plot([-106,-106,-108,-108,-106],[16,18,18,16,16],color='k',label='North ODZ') # P2
plt.plot([-91,-91,-89,-89,-91],[8,10,10,8,8],color='r',linestyle='--',label='Costa Rica Dome') # CRD
plt.plot([-160,-85,-107,-160],[8,8,24,8],color='k',linestyle='--',label='ODZ boundaries')


plt.xlabel('Longitude/°E', labelpad=20, fontsize=11)
plt.ylabel('Latitude/°N', labelpad=35, fontsize=11)
plt.legend(loc='upper left')


X, Y = np.meshgrid(x, y) # mesh the x and y


C=plt.contourf(X,Y,Z,levels=np.linspace(26,27,11),cmap='plasma',vmin = 26, vmax =27, extend="neither",) 
cbar = plt.colorbar(shrink = 0.45,)
cbar.ax.set_ylabel('Core Oxygen Deficient Layer\nPotential Density/kg $m^{-3}$')
plt.savefig('cross-odz.tif', dpi='figure', format=None)
plt.show()


#%% Plot a larger map

Nedge=40
Sedge=1
Wedge=-165
Eedge=-80

longlineE=Eedge
longlineW=Wedge
longlinespacing=10

latlineN=Nedge
latlineS=0
latlinespacing=5

fig = plt.figure(figsize=(8, 8))
plt.rcParams["font.family"] = "sans"
m = Basemap(projection='cyl', resolution='i',
            llcrnrlat=Sedge, urcrnrlat=Nedge,
            llcrnrlon=Wedge, urcrnrlon=Eedge, )
m.shadedrelief(scale=0.2, alpha=0.5)
m.drawcoastlines()
m.drawparallels(np.arange(latlineS,latlineN,latlinespacing),labels=[1,0,0,0], fontsize=11, labelstyle= "+/-", fmt=format_string)
m.drawmeridians(np.arange(longlineW,longlineE,longlinespacing),labels=[1,1,0,1], fontsize=11, labelstyle= "+/-", fmt=format_string)
#plt.plot([-106,-106,-108,-108,-106],[16,18,18,16,16],color='k',label='North ODZ') # P2
#plt.plot([-91,-91,-89,-89,-91],[8,10,10,8,8],color='r',linestyle='--',label='Costa Rica Dome') # CRD
plt.plot([-160,-85,-107,-160],[8,8,24,8],color='k',linestyle='--',label='OMZ boundaries')
plt.plot([-130,-130,-85,-85,-130],[5,30,30,5,5],color='b',linestyle='-')

plt.xlabel('Longitude/°E', labelpad=20, fontsize=11)
plt.ylabel('Latitude/°N', labelpad=35, fontsize=11)
#plt.legend(loc='upper left')

#plt.savefig('ETNP_OMZ_large.tif', dpi='figure', format=None)
plt.show()
