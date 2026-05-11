# CESM2 Sea Ice Regridding

This folder contains scripts for regridding CESM2-LE daily sea ice concentration output (`aice_d`) to a common 1° × 1° Arctic latitude–longitude grid.

## Purpose

Sea ice concentration is used to define the sea ice substrate required for rain-on-snow-on-ice (ROSI) detection. A threshold of ≥30% sea ice concentration is applied to identify sea ice presence.

Regridding ensures consistency with ERA5 and other CESM2-derived variables used throughout the analysis.

## Input

CESM2-LE daily sea ice concentration output:

- Historical: `BHISTsmbb`
- Future scenario: `BSSP370smbb`
- Variable: `aice_d`

## Output

Regridded daily sea ice concentration fields used for ROSI event detection and habitat analysis.
