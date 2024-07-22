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
  You can maximize the view your mainly working with by clicking on the square icon ![](screenshots/hud_05.png) in the top right corner.
  To get all views back, click on the quadview icon ![](screenshots/hud_06.png).
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
Use our [Fiji Plugin][fiji-plugin] (can be done efficiently in [a macro][fiji-h5-conv]), from Python using a [Jupyter notebook][jupyter-h5-conv].

## Workflow-specific tips

### Pixel classification / Autocontext - Exporting probabilities

When exporting Probabilities, go to Export Image Settings, tick `Convert to Data Type` (choose integer 8-bit), as well as `Renormalize [min,max]` (from `0 ... 1.0` to `0 ... 255`).
Intuitively, we think of probabilities as values between 0 and 1, or maybe we multiply those values by 100 to obtain percentages.
Fractions are represented for computations as 32-bit floating point values.
The output of the random forest classifier is not continuous between 0 and 1, however.
It can only take discrete values corresponding to integer percentages: `0.00` (0%), `0.01` (1%), `0.02` (2%) etc. Not for example `0.015` (1.5%) or anything else that would correspond to a fractional percentage.
This means the values can be converted to 8-bit integers without losing information.
Working with 8-bit integers instead of 32-bit floating point numbers is faster, and the resulting exported files are smaller to store.

## Hardware considerations

### CPU

Computations in ilastik are done in parallel whenever possible.
Having a CPU with multiple cores will result in faster performance.

### Memory/RAM

Block-wise computations are more efficient with increasing block-size.
Having more RAM available means ilastik can work more efficiently.
3D data will in general require more RAM.
E.g. we would not recommend to attempt processing 3D data in the [Autocontext][autocontext] with less than 32 Gb of RAM.

### GPU

Currently only workflows that use deep neural networks ([Neural Network Workflow][nnwf], [Trainable Domain Adaptation][tda]) support doing calculations on a GPU.
If you have an NVidia graphics card, download and install the `-gpu` builds from [our download page][downloads] to gain vastly improved performance in these workflows.

Other workflows, like Pixel- or Object Classification do not use the GPU for calculations.

### Apple Silicon Support

Apple Silicon Hardware is fully supported in the [latest beta release][dl-beta].

[autocontext]: {{site.baseurl}}/documentation/autocontext/autocontext.html
[dl-beta]: {{site.baseurl}}/download.html#beta
[downloads]: {{site.baseurl}}/download.html
[fiji-h5-conv]: https://github.com/ilastik/ilastik4ij/blob/main/examples/convert_tiff_to_ilastik_h5.ijm
[fiji-plugin]: https://github.com/ilastik/ilastik4ij#ilastik-imagej-modules
[jupyter-h5-conv]: https://github.com/ilastik/ilastik/blob/main/notebooks/h5convert/convert_to_h5.ipynb
[nnwf]: {{site.baseurl}}/documentation/nn/nn.html
[tda]: {{site.baseurl}}/documentation/tda/tda.html
