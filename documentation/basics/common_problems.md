---
title: FAQ / Common Problems 
tagline: Tips, tricks and workarounds
category: "Documentation"
group: "basic-documentation"
weight: 7
---
# Common problems and questions, tips, tricks and workarounds.

If you are experiencing a problem with ilastik which we haven't yet described below, please [let us know]({{site.baseurl}}/community.html)! 
If your problem is already described, [tell us anyway]({{site.baseurl}}/community.html) and we'll adjust our priority list.

#### 1) My dataset is loaded, but the image looks transposed or it's stacked along "z" instead of "t"
This can be fixed by editing the dataset properties, as described [here]({{site.baseurl}}/documentation/basics/dataselection#properties).

#### 2) I am trying to load a multipage tiff file, but something is going wrong
We keep working on making all multipage tiffs load seamlessly. If your use case is still not fixed, there are two workarounds:

* Try the [Fiji Import/Export plugin]({{site.baseurl}}/documentation/fiji_export/plugin) and export your data to ilastik favorite hdf5 format

* Export your data as a sequence of tiffs rather than a single multipage tiff file.

#### 3) Navigation is slow/lagging
ilastik works best if the input data is in the hdf5 format. Here are some options:

* Use the [Fiji Import/Export plugin]({{site.baseurl}}/documentation/fiji_export/plugin) and export your data to ilastik favorite hdf5 format

* Use ilastik's Data Conversion workflow

* In the [Dataset Properties Editor]({{site.baseurl}}/documentation/basics/dataselection#properties) change the ``storage`` option to ``Copied to project file``

* Write a custom script in Python using the h5py library

#### 4) My exported results are all black!
ilastik exports probability maps or segmentations. The former have a range from 0 to 1 and by default they are of type float. This is convenient for automatic post-processing, but not for visual inspection. To export as a viewable image, change the output type to ``unsigned int, 8 bit`` and renormalize the range from (0, 1) to (0, 255). More details on these operations can be found [here]({{site.baseurl}}/documentation/basics/export#settings). If you are exporting a segmentation, ilastik saves it as a labeled image, so every pixel has the value of the most probable label found during classification. If you had, say, 3 labels, your image is composed of values 1, 2 and 3, which looks black if viewed raw. An image like this should be displayed with a ``lookup table``. For example, ``glasbey`` LUT in Fiji usually works well, but you can also define your own if you have specific class colors in mind.

#### 5) Can I just select all features?
For [Pixel Classification workflow]({{site.baseurl}}/documentation/pixelclassification/pixelclassification) you can select all. In theory and in our own practice, there should be no negative effect on the classification accuracy. However, computing more pixel features is slower than computing less.  

The situation is a little different for the [Object Classification workflow]({{site.baseurl}}/documentation/objects/objects). Here most of the feature computation time is spent in looping over the image and adding more features does not bring a substantial overhead. However, you have to be careful not to select ``Location``-based features for classification (such as ``object center``), unless they really are important for your data (say, if objects of one class tend to assemble at the top of the image and of the other at the bottom). If the object class is independent from the object location, adding location-based features can confuse the classifier. Also, if the background of your iamges is uniform, it does not make sense to select ``in neighborhood`` features. For the rest, we recommend selecting all in the ``Object Extraction`` applet and trying out different subsets in ``Object Classification``. This setup provides the most flexibility, as you don't have to wait for feature computation over and over again.

#### 6) How can I view individual channels of my input data?
2- and 3-channel data is loaded as RGB by default. To examine the channels one by one, you again have to go to the [Dataset Properties dialog]({{site.baseurl}}/documentation/basics/dataselection#properties) and change the ``Channel Display`` setting. After you do that, a tiny channel spinbox should appear at the Raw data layer in the lower left corner of the ilastik window. 

#### 7) How can I adjust the brightness/contrast of my image for Training?
If you display individual channels rather than a composite image, you should see a [Window Leveling button]({{site.baseurl}}/documentation/pixelclassification/pixelclassification#window) in the Training applet. This has no effect on the classifier, but makes the labeling process simpler.

#### 8) How can I know if the classifier is doing well?
Interactive labeling and visual inspection are the most convenient way. If you want a quantitative measure, Random Forest internally computes the so called [Out-of-bag error](https://en.wikipedia.org/wiki/Out-of-bag_error). It is printed to the ilastik log file, but not (yet) displayed in the ilastik window. The corresponding lines in the log should look something like this: "INFO 2017-02-24 10:41:12,555 parallelVigraRfLazyflowClassifier 12179 140573765494528 Training complete. Average OOB: 0.225149500876". The OOB here is the out-of-bag error. 

#### 9) Pixel+object classification workflow is slow/consumes too much RAM
Separate the project in two workflows: do pixel classification first, export the prediction results and then start a new object classification workflow. The reason the combined workflow is sometimes slow, especially for bigger data, is that filtering objects by size which happens in the Thresholding applet, is a global operation which can not be done blockwise. This means that every pixel, in the whole dataset, in the pixel classification part needs to be computed before thresholding is applied. 

#### 10) I have labels already, can I import them?
Yes, the procedure is explained [here]({{site.baseurl}}/documentation/pixelclassification/pixelclassification#import). But keep in mind that ilastik is not designed to work with dense labels, we assume that the features-labels matrix for the classifier will fit in RAM. 

#### 11) Can I process 3D data as 2D?
Yes, there is a workaround for this. The trick is treating the dataset as a time series instead of a 3D stack. So, in the data input applet, go to the [Dataset Properties dialog]({{site.baseurl}}/documentation/basics/dataselection#properties) and change the z-axis for a t-axis. Now your data will be processed one slice at a time.

If it is only Pixel Classification you are interested in, then you can do this since ilastik `1.3.2` by selecting 2D instead of 3D for the respective feature in the [Feature Selection applet]({{site.baseurl}}/documentation/pixelclassification/pixelclassification#selecting-good-features).

 
