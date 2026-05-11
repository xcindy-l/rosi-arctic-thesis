# NASA / NSIDC Sea Ice Regridding

This folder contains scripts for processing and regridding observational sea ice concentration data from the NOAA/NSIDC Climate Data Record (CDR).

## Purpose

Satellite-derived sea ice concentration data are used to define observed sea ice extent for historical ROSI detection and CESM2-LE model evaluation.

Sea ice presence is defined using a threshold of ≥30% concentration.

## Input

NOAA / NSIDC Climate Data Record (CDR) of passive microwave sea ice concentration:

- Dataset version: CDR Version 4
- Spatial resolution: ~25 km
- Period: **1980–2021**

## Output

Regridded daily sea ice concentration fields on a common 1° × 1° Arctic grid used in observational ROSI analysis.
