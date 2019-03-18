---
title: Release notes for v1.2.2
---

A lot of improvements in tracking:

- Piecewise solving for large videos
- Export of results in multiple formats, including contours
-- Mamut export for proof-reading the results in Mamut
- Batchmode of tracking with learning does not require CPLEX anymore
- Label assist to guide the user to frames with very big objects (potential merges) or probable divisions 
- Fix for the [bug](https://github.com/ilastik/ilastik/issues/1432) that prevented tracking to work at all on 3D+t data

Data Input:

- Stacks of h5 files, combining the datasets in the same file or across different files. This finally allows to make txyz stacks from multiple xyz h5 files or txy h5 files

Thresholding:

- Different channels for core and final, possibility to preserve identities in the final step

General performance:

- Better handling of large 2D data by increasing default tile size. Users can experiment via a menu item under View

Boundary-based segmentation with Multicut:

- Improvements in UI (live mode for multicut, etc.)

Documentation:

- Detailed documentation for animal tracking, including example videos
- Step-by-step guides to Multicut and Autocontext workflows

Bug fixes, performance improvements, better code via inner re-factoring...
