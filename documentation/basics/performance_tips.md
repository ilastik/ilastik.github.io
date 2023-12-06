---
title: Performance tips
tagline:
category: "Documentation"
group: "basic-documentation"
weight: 7
---

# Performance tips when working with ilastik

## Usage tips

### Navigation

* ilastik will (ideally) only work on the parts of the data that you are currently viewing:
  if you zoom out more → ilastik will have to calculate results for a larger area which will take more time for the view to update.
* As a consequence, in 3D: if you have all 3 views open but only look at one of them → 3 times the work without benefit.
  You can maximize the view your mainly working with by clicking on the square icon ![][screenshot-maximize-icon] in the top right corner.
  To get all views back, click on the quadview icon ![][screenshot-minimize-icon].
* scrolling through 3D volumes/time series ilastik will predict every (time) slice even if it's only scrolled through
  → disable live update when doing any larger navigation.

### Training shallow learning classifiers:

Training time depends on number of training samples (e.g. annotated pixels).
Adding lot of very similar “looking” pixels will not improve the classifier, but increase the training time a lot.
It is good practice to start with few annotations, go to live update and correct the classifier where it's wrong.

### File Formats

Lazy access (and parallelization) require file formats that store volumes in chunks (squared tiles, blocks).
File formats that allow efficient reading of sub-volumes will perform better.
in ilastik we support `.h5` (hdf5) for small/medium data, `.n5` for large data.

How to convert your data?
Use our [Fiji Plugin][fiji-plugin] (can be done efficiently in [a macro][fiji-h5-conv], from Python using a [Jupyter notebook][jupyter-h5-conv].


[fiji-h5-conv]: https://github.com/ilastik/ilastik4ij/blob/main/examples/convert_tiff_to_ilastik_h5.ijm
[fiji-plugin]: https://github.com/ilastik/ilastik4ij#ilastik-imagej-modules
[jupyter-h5-conv]: https://github.com/ilastik/ilastik/blob/main/notebooks/h5convert/convert_to_h5.ipynb
[screenshot-maximize-icon] screenshots/hud_05.png
[screenshot-minimize-icon] screenshots/hud_06.png

