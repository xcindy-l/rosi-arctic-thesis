# CESM2 Rain-on-Sea-Ice (ROSI Rain) Regridding

This folder contains scripts for processing and regridding CESM2-LE rainfall (`rain_d`) to a common 1° × 1° Arctic grid.

## Purpose

Rainfall is a key atmospheric variable for rain-on-snow-on-ice (ROSI) detection.

In CESM2, rainfall is explicitly resolved and can be analyzed separately from snowfall. Processed rainfall fields are combined with sea ice concentration and snow-on-sea-ice datasets to identify ROSI events.

## Input

CESM2-LE daily rainfall output:

- Historical: `BHISTsmbb`
- Future scenario: `BSSP370smbb`
- Variable: `rain_d`

## Output

Regridded daily rainfall fields over sea ice used in ROSI detection and rain-on-ice analyses.
