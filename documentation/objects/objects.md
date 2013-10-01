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
in
[Pixel Classification workflow]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html)
and then thresholding the probability maps to obtain a segmentation. 

![](figs/input_pixel_class.png)

If you have pre-computed probability maps, you can also use

* Object Classification (from prediciton image)
The data input applet of this workflow expects you to load the probability maps:

![](figs/input_prediction_image.png)

* Object Classification (from binary image)
This workflow should be used, if you already have a binary segmentation image. 
The image should be loaded in the data input applet:

![](figs/input_segmentation_image.png)

##From probabilities to a segmentation - "Threshold and Size Filter" applet
If you already have binary segmentation images, skip this section.

Suppose we have a probability map for a 2-class classification, which looks like this:
![](figs/pixel_results.png)

There are two ways to transform a probability map into a segmentation in ilastik and both are covered by the thresholding applet. To see the results of changing the parameter settings in this applet, press the "Apply" button.

First, specify which channel of the probability map you want to threshold (we choose channel 1, as it corresponds to object rather than background probability). The "Selected input channel" layer will show you the channel you selected in the corresponding label color:

![](figs/thresholding_channel.png)

After selecting the channel, choose a sigma to smooth the probability map with a Gaussian. The Gaussian can be anisotropic, i.e. sigmas for all dimensions can be different. If you do not want to smooth, just select a very small sigma (like 0.6). You can check the results of the smoothing operation by first activating the "Show intermediate results" checkbox and then looking at the "Smoothed input" layer:

![](figs/thresholding_sigmas.png)

Now, two options are available for the actual thresholding, as shown in the little tab widget "One Threshold/Two Thresholds".

The **"One Threshold"** tab performs regular thresholding, followed by the size filter. For debugging purposes, we also provide a view on the thresholded objects before size filtering. This layer is activated by checking the "Show intermediate results" checkbox.

![](figs/thresholding_before_size_filter.png)

The **"Two Thresholds"** tab performs hysteresis thresholding with two thresholds: high and low. The high threshold is applied first and the resulting objects are filtered by size. For the remaining objects the segmentation is then relaxed to the level of low threshold. The two levels of thresholding allow to separate the criteria for detection and segmentation of objects and select only objects of very high probability while better preserving their shape. As for the single threshold case, we provide a view on the intermediate results after the application of the high threshold, the size filter and the low threshold. The image below shows the results of the high (detection) threshold in multiple colors overlayed with the results of the low (segmentation) threshold in white:

![](figs/thresholding_two_thresholds.png)

The last parameter of this applet is the size filter, for which you can specify the minimum and maximum value. For both thresholding methods the end result is shown in the "Final output" layer.

Now that we have obtained a segmentation, we are ready to procede to the "Object Feature Selection" applet.

##From segmentation to objects - "Object Feature Selection" applet
This applet finds the connected components (objects) in the provided binary segmentation image and computes user-defined features for each object. If you want to inspect the connected components, activate the "Objects (connected components) layer. If you select any object features, connected component analysis will be performed automatically.

![](figs/object_extraction_cc.png)

The following dialog will appear if you press the "Select features" button:

![](figs/object_extraction_selection_dialog.png)

The "Standard Object Features" refer to the built-in ilastik features, computed by the [vigra library](http://hci.iwr.uni-heidelberg.de/vigra/doc/vigra/group__FeatureAccumulators.html). Unless otherwise specified by the "Coord" prefix, the features are computed on the grayscale values of the pixels that belong to the object. You will also notice features, which can be computed "in the neighborhood". In that case, the neighborhood of the object ( specified by the user at the bottom of the dialog) is found by distance transform and the feature is computed for the object itself and for the neighborhood including and excluding the object.

![](figs/object_extraction_selection_dialog_neigh.png)

Once you have selected the features you like, the applet will proceed to compute them. For large 3D datasets this step can take quite a while. However, keep in mind that most of the time selecting more features at this step is not more expensive computationally. We therefore recommend that you select all features you think you might try for classification and then choose a subset of these features in the next applet.

##Prediction for objects - "Object Classification" applet
This applet allows you to label the objects and classify them based on the features, computed in the previous applet. If you want to choose a subset of features, press the "Subset features" button. Adding labels and changing their color is done the same way as in the
[Pixel Classification workflow]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html).
For a particular example, let us examine the data more closely by activating only the "Raw data" layer:

![](figs/oc_raw.png)

Clearly, two classes of cells are present in the image: one more bright but variable, the other darker and more homogenous. Hopefully, the two classes can be separated by the grayscale mean and variance in the objects. Let us select these two features and add two labels. 

![](figs/oc_subset.png)

Note, that the list of features now only contains the few features that were selected in the previous applet. To label objects, either simply left-click on them or right-click and select the corresponding option. Right-clicking also allows you to print the object properties in the terminal. To trigger classification, check the "Live Update" checkbox.

![](figs/oc_add_labels.png)

If the "Live Update" checkbox is activated, the prediction is interactive and you can receive immediate feedback on your labels. Let us examine the prediction results:

![](figs/oc_prediction1.png)

In the low right corner we see a cell (shown by the red ellipse), which was classified as "green", while it is most probably "red". Let's label it "red" and check the results again:

![](figs/oc_prediction2.png)

All cells seem to be classified correctly, except one segmentation error, where two cells were erroneously merged (shown by the red ellipse). How could we correct that? We'd have to go back to the thresholding applet, where we performed the segmentation. In the best case, you would have caught this error by examining the thresholding output at the first step. The problem with correcting the segmentation now is that with different thresholds the objects will most probably change shape and thus their features. Besides, some objects might disappear completely, while others appear from the background. ilastik will try to transfer your object labels from the old to the new segmentation, but it will fail in case of disappearance or object division, which is why it's recommended to not change the segmetation after labels are added. Nevertheless, let us try it for demonstrational purposes:

![](figs/thresholding_final2.png)

After a slight change in the segmentation (lower) threshold the objects indeed become separated. And the two independent objects are predicted correctly:

![](figs/oc_prediction3.png)

##Preparing for large scale prediction - Blockwise Object Classification applet
Segmentation and connected components analysis in the applets above is performed on the *whole dataset* simultaneously. While these operations and especially the hysteresis thresholding require a lot of memory, "whole image" processing is sufficient for most 2D images. However, for large 3D image volumes we have to resort to blockwise processing. This applet allows you to experiment with different block and halo sizes on the data you used in the interactive object prediction and, by comparing the "whole image" interactive prediction and blockwise prediction, find the optimal parameters for your data. Let us try to predict our image blockwise:

![](figs/block_oc_pred.png)
In the upper right corner, an object is shown for which the blockwise object classification clearly failed. This object, however, will be predicted correctly if we choose a more reasonable block and halo size. Supposing we found such sizes, let us proceed to batch prediction itself

##Large-scale prediction - Batch Prediction applets
These two applets have the same interface and parameters as batch prediction in
[Pixel Classification workflow]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html).
The only difference is that you started the object classification workflow from binary images or prediction images, you'll have to provide them here as well:

![](figs/batch.png)




 



