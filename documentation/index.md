---
layout: documentation
title: Overview
category: "Documentation"
group: "documentation-home"
---

# Overview

## User documentation
[Here]({{site.baseurl}}/documentation/ilastik_manual.pdf) you can find a detailed manual 
for using ilastik together with FiJi, written by Chong Zhang for the bioimage analysis
training course organized by CellNetworks in Heidelberg. 


After starting ilastik, you will be greeted by the
[startup screen]({{site.baseurl}}/documentation/basics/startup.html).
There you can select one of the available workflows
([pixel classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html),
[object classification]({{site.baseurl}}/documentation/objects/objects.html),
[tracking]({{site.baseurl}}/documentation/tracking/tracking.html),
[density counting]({{site.baseurl}}/documentation/counting/counting.html),
or [carving]({{site.baseurl}}/documentation/carving/carving.html)).

[Pixel classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html) divides all pixels in the image into classes you define. You have to interactively supply sparse example annotations of each class and choose appropriate pixel-level features.  
[Object classification]({{site.baseurl}}/documentation/objects/objects.html) operates on the image and its segmentation mask. From the segmentation mask it extracts objects, which are then assigned to different classes you define. You have to interactively perform example object assignments and choose object-level features.  
[Tracking]({{site.baseurl}}/documentation/tracking/tracking.html) allows you to track objects over the time axis of the dataset. 2D and 3D data, dividing objects and many other options are supported.  
[Density counting]({{site.baseurl}}/documentation/counting/counting.html) counts objects in 2D images without segmenting them first. This workflow can count even in very crowded images with many object overlaps.  
[Carving]({{site.baseurl}}/documentation/carving/carving.html) refers to semi-automatic interactive segmentation of 2D and 3D data. You have to supply sparse foreground/background seeds, and the workflow "carves" the object in the whole dataset.  

To get started, load your data using the
[data selection]({{site.baseurl}}/documentation/basics/dataselection.html)
applet.
To learn how to navigate and interact with you data, read the
[navigation]({{site.baseurl}}/documentation/basics/navigation.html)
documentation as well as the
[layers]({{site.baseurl}}/documentation/basics/layers.html)
documentation.

## Developer documentation
[Developer Documentation]({{site.baseurl}}/development.html)
