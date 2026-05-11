#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#!/glade/u/apps/jupyterhub/jh-23.11/bin/python
import sys
import xarray as xr
import numpy as np
import xesmf as xe
import os

# Command line arguments
f_in = sys.argv[1]          # Input CESM2 SMBB file
output_dir = sys.argv[2]     # Output directory
filename = sys.argv[3]       # Base filename for output
f_out = os.path.join(output_dir, f"{filename}_aice_1deg.nc")

# Open dataset
ds = xr.open_dataset(f_in)

# Check for 'aice_d'
if 'aice_d' not in ds.data_vars:
    print(f"Skipping {filename}: no aice_d variable.")
    sys.exit(0)

# Arctic subset (lat >= 30)
ds = ds.where(ds['TLAT'] >= 30, drop=True)

# Prepare output grid
lat_out = np.arange(30.5, 91, 1)
lon_out = np.arange(-179.5, 180, 1)
ds_out_grid = xr.Dataset({'lat': (['lat'], lat_out),
                          'lon': (['lon'], lon_out)})

# Create xESMF regridder using the full dataset coordinates
ds_temp = ds[['aice_d']].rename({'TLON': 'lon', 'TLAT': 'lat'})
regridder = xe.Regridder(ds_temp.isel(time=0), ds_out_grid, 'bilinear', periodic=True)

# List to hold yearly regridded DataArrays
regridded_years = []

# Loop over each year
for year in np.unique(ds['time'].dt.year):
    ds_year = ds.sel(time=ds['time'].dt.year == year)
    ds_temp_year = ds_year[['aice_d']].rename({'TLON': 'lon', 'TLAT': 'lat'})
    
    ds_regridded = regridder(ds_temp_year['aice_d'])
    ds_regridded.name = 'aice_d'
    regridded_years.append(ds_regridded)

    print(f"Processed year {year}")

# Combine all years along time
ds_all = xr.concat(regridded_years, dim='time')

# Save to NetCDF
ds_all.to_netcdf(f_out)
print(f"Saved regridded Arctic 1° file: {f_out}")

