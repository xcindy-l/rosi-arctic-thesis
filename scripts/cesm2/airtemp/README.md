# CESM2 Air Temperature Regridding

This folder contains scripts for regridding daily CESM2-LE 2 m air temperature (`TREFHT`) output to a common 1° × 1° Arctic latitude–longitude grid for use in Arctic rain-on-snow-on-ice (ROSI) analysis.

## Purpose

Air temperature is used to partition precipitation phase (rain vs. snow) and to evaluate temperature conditions relevant to ROSI occurrence. Native CESM2 output is regridded to a common grid to ensure consistency with ERA5, NASA sea ice products, and other CESM2 variables used in this study.

## Input Data

CESM2-LE daily air temperature (`TREFHT`) files:

- Historical: `BHISTsmbb`
- Future scenario: `BSSP370smbb`
- Variable: `TREFHT`

Input files are stored on NCAR Glade:

```text
/glade/work/xliu1/cesm2_airtemp_regrid/
