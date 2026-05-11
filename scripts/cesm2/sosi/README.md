# CESM2 Snow-on-Sea-Ice (SOSI) Regridding

This folder contains scripts for processing and regridding CESM2-LE snow depth over sea ice (`vsnon_d`) to a common 1° × 1° Arctic grid.

## Purpose

Snow depth over sea ice is a critical substrate variable for rain-on-snow-on-ice (ROSI) detection and ringed seal habitat assessment.

CESM2 provides snow depth separately across sea ice thickness categories. These values are combined to calculate total snow depth per grid cell prior to regridding.

## Input

CESM2-LE daily snow-on-sea-ice output:

- Historical: `BHISTsmbb`
- Future scenario: `BSSP370smbb`
- Variable: `vsnon_d`

## Output

Regridded daily snow depth fields over sea ice used in ROSI detection and snow-on-ice analyses.
