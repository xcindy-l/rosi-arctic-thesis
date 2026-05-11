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
f_in = sys.argv[1]          # Input CESM2 TREFHT file
output_dir = sys.argv[2]     # Output directory
filename = sys.argv[3]       # Base filename for output
f_out = os.path.join(output_dir, f"{filename}_TREFHT_1deg.nc")

# Open dataset
ds = xr.open_dataset(f_in)

# Check for TREFHT variable
if 'TREFHT' not in ds.data_vars:
    print(f"Skipping {filename}: no TREFHT variable.")
    sys.exit(0)

# Arctic subset (lat >= 30)
ds = ds.where(ds['lat'] >= 30, drop=True)

# Prepare output grid (regular 1° lat-lon, 30–90N)
lat_out = np.arange(30.5, 91, 1)
lon_out = np.arange(-179.5, 180, 1)
ds_out_grid = xr.Dataset({
    'lat': (['lat'], lat_out),
    'lon': (['lon'], lon_out)
})

# Create xESMF regridder (unique weights file per case)
regridder = xe.Regridder(
    ds,
    ds_out_grid,
    method='bilinear',
    periodic=True,
    filename=os.path.join(output_dir, f"{filename}_weights.nc"),
    reuse_weights=False
)

# Regrid variable
ds_regridded = regridder(ds['TREFHT'])
ds_regridded.name = 'TREFHT'

# Preserve attributes
ds_regridded.attrs = ds['TREFHT'].attrs

# Save to NetCDF
ds_regridded.to_netcdf(f_out)
print(f"✅ Saved regridded Arctic 1° TREFHT file: {f_out}")

