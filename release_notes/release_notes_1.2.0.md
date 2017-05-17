---
layout: default
title: Release notes for v1.2.0
---

News:

* On Linux and Mac, tracking no longer requires CPLEX as long as you set the parameters manually or use the default values. "Tracking with learning" workflow still needs CPLEX. 
* A new workflow for segmentation based on boundary evidence: Edge Training with Multicut. 

Fixes:

* Input of tiff files has been fixed
* Tracking with learning automatically avoids negative weights
* Multiple performance optimizations in tracking
* Memory limits are much better enforced
* Object features have detailed built-in docs
