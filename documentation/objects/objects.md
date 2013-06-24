---
layout: documentation
title: Object Classification
tagline: Object Classifcation
category: "Documentation"
group: "workflow-documentation"
---

#Object Classification Workflow
##Input

As the name suggests, object classification workflow aims to classify full *objects*, based on object-level features and user annotations. 
In order to do so, the workflow needs *segmentation* images besides the usual raw image data. Depending on the availability of these 
segmentation images, the user can choose between three flavors of object classification workflow, which differ by their input data:

![](figs/ilastik_start_screen.png)

* Object Classification (from pixel classification)
This is a combined workflow, which lets you start from the raw data, perform pixel classification as described 
in <a href="/kategorien/20_Documentation/dateien/ilastik_carving_documentation/">Classification
module</a> and then thresholding the probability maps to obtain a segmentation. 

![](figs/input_pixel_class.png)

If you have pre-computed probability maps, you can also use

* Object Classification (from prediciton image)
The data input applet of this workflow expects you to load the probability maps:

![](figs/input_prediction_image.png)

* Object Classification (from binary image)
This workflow should be used, if you already have a binary segmentation image. 
The image should be loaded in the data input applet:

![](figs/input_segmentation_image.png)

##From pixels to objects - thresholding
If you already have binary segmentation images, skip this section.

There are two ways to transform a probability map into a segmentation in ilastik and both are covered by the thresholding applet. The "One Threshold" tab performs regular thresholding, followed by the size filter. For debugging purposes, we also provide a view on the thresholded objects before size filtering.

The "Two Thresholds" tab performs hysteresis thresholding with two thresholds: high and low. The high threshold is applied first and the resulting objects are filtered by size. For the remaining objects the segmentation is then relaxed to the level of low threshold. As for the single threshold case, we provide a view on the results after the application of the high threshold, the size filter and the low threshold.

We are now ready to procede to the "Object Extraction" applet.


