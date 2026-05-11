# ERA5 Regridding

This folder contains scripts for processing and regridding ERA5 observational data used in Arctic rain-on-snow-on-ice (ROSI) analysis.

## Purpose

ERA5 provides observationally derived atmospheric and snow variables used to evaluate CESM2-LE performance during the historical period (1980–2021).

Variables include:

- Snow depth (`snod`)
- Total precipitation (`tp`)
- 2 m air temperature (`t2m`)

Rainfall is estimated using temperature-based precipitation phase partitioning.

## Input

ERA5 reanalysis products from the European Centre for Medium-Range Weather Forecasts (ECMWF):

Period: **1980–2021**

## Output

Regridded ERA5 observational fields used for historical ROSI reconstruction and model validation.
