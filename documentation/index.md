---
layout: documentation
title: Overview
category: "Documentation"
group: "documentation-home"
---

# Overview

## User documentation

### Complete tutorials
[Here]({{site.baseurl}}/documentation/ilastik_manual.pdf) you can find a detailed manual 
for using ilastik together with FiJi, written by Chong Zhang for the bioimage analysis
training course organized by CellNetworks in Heidelberg. 

An in-depth tutorial for ilastik tracking can be found in [this book chapter](https://hciweb.iwr.uni-heidelberg.de/node/6055).
This tutorial also includes pixel and object classification.

The [CellProfiler Blog](https://blog.cellprofiler.org/) has a [helpful post](https://blog.cellprofiler.org/2017/01/19/cellprofiler-ilastik-superpowered-segmentation/)
about using ilastik segmentations in CellProfiler, including good advice for labeling (brushing) techniques for generating a precise segmentation.

### Online documentation
After starting ilastik, you will be greeted by the
[startup screen]({{site.baseurl}}/documentation/basics/startup.html).
There you can select one of the available workflows:
[Pixel Classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html),
[Autocontext]({{site.baseurl}}/documentation/autocontext/autocontext),
[Object Classification]({{site.baseurl}}/documentation/objects/objects.html),
[Tracking]({{site.baseurl}}/documentation/tracking/tracking.html),
[Animal Tracking]({{site.baseurl}}/documentation/animalTracking/animalTracking.html),
[Density Counting]({{site.baseurl}}/documentation/counting/counting.html),
[Carving]({{site.baseurl}}/documentation/carving/carving.html)),
[Boundary-based Segmentation with Multicut]({{site.baseurl}}/documentation/multicut/multicut).

**To get started**, load your data using the
[data selection]({{site.baseurl}}/documentation/basics/dataselection.html)
applet. We can load most common image formats and we also have a [Fiji plugin]({{site.baseurl}}/documentation/fiji_export/plugin) to convert anything Fiji can read into ilastik favorite hdf5 data format.
To learn how to navigate and interact with you data, read the
[navigation]({{site.baseurl}}/documentation/basics/navigation.html)
documentation as well as the
[layers]({{site.baseurl}}/documentation/basics/layers.html)
documentation.

[Pixel classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html) divides all pixels in the image into classes you define. You need to interactively supply sparse example annotations of each class and choose appropriate pixel-level features.  
[Autocontext]({{site.baseurl}}/documentation/autocontext/autocontext) improves [Pixel classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html) results by performing cascaded classification. You need to train two rounds of pixel classification, the results of the first one will be used as features in the second one.  
[Object classification]({{site.baseurl}}/documentation/objects/objects.html) operates on the image and its segmentation mask. From the segmentation mask it extracts objects, which are then assigned to different classes you define. You have to interactively perform example object assignments and choose object-level features.  
[Tracking]({{site.baseurl}}/documentation/tracking/tracking.html) allows you to track objects over the time axis of the dataset. 2D and 3D data, dividing objects and many other options are supported. On Windows, the automatic tracking workflow uses an external CPLEX library for optimization. Instructions on how to install CPLEX are given [here]({{site.baseurl}}/documentation/basics/installation.html).   
[Animal tracking]({{site.baseurl}}/documentation/animalTracking/animalTracking.html) allows you to track lab animals (eg: flies, mice, larvae, zebrafish) in 2d+t or 3d+t videos.   
[Density counting]({{site.baseurl}}/documentation/counting/counting.html) counts objects in 2D images without segmenting them first. This workflow can count even in very crowded images with many object overlaps.  
[Carving]({{site.baseurl}}/documentation/carving/carving.html) refers to semi-automatic interactive segmentation of 2D and 3D data. You have to supply sparse foreground/background seeds, and the workflow "carves" the object in the whole dataset.  
[Boundary-based Segmentation with Multicut]({{site.baseurl}}/documentation/multicut/multicut) allows you to segment objects based on boundary information. This is especially useful for electron microscopy data or any other data with membrane staining. You need to provide boundary-level labels and the workflow solves an optimization problem to come up with closed-surface objects with no dangling edges.  

### Something is wrong or unclear?
Check the [Common Problems section]({{site.baseurl}}/documentation/basics/common_problems), perhaps there is a workaround. And don't hesitate to [contact us]({{site.baseurl}}/community.html) with your complaints and feature requests.



## Developer documentation
[Developer Documentation]({{site.baseurl}}/development.html)
