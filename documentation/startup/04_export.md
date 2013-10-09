---
layout: documentation
title: Export
tagline:
category: "Documentation"
group: "basic-documentation"
permalink: export.html
---
#Export
In the machine learning based ilastik workflows such as the
[Pixel Classifcation workflow]({{site.baseurl}}/documentation/objects/objects.html) and the [Density Counting workflow]({{site.baseurl}}/documentation/counting/counting.html), the user interctively trains a classifier on a rapresentative set of images. After that training step, the generated classifier can be used to make predictions for useen images.

<!-- The following documentation applies to the [Density Counting workflow]({{site.baseurl}}/documentation/counting/counting.html) and to the [Pixel Classifcation workflow]({{site.baseurl}}/documentation/objects/objects.html). -->

## Export Predictions
????


## Batchprocessing unseen images
The following tutorial demonstrates the batch prediction for the [Pixel Classifcation workflow]({{site.baseurl}}/documentation/objects/objects.html) the same procedure applies also to the [Density Counting workflow]({{site.baseurl}}/documentation/counting/counting.html).

The first step in batch prediction is the selection of the input files.

![](screenshots/batch1_zoomed.png)

When clicking on the **Add files** button, the user can choose between adding
single or multiple files from the File selection dialog, or adding files matching a pattern from a directory (last option). This is especially useful when large amounts of images have to be processed.

The next step is the actual batch processing itself. In the **Batch Prediction output location** applet, the user can configure the output format using the **Choose Settings** button. This allow for example to save the results of the workflow as ".png" images rather than ".tiff" or ".h5" files. For novice users the default settings should be fine, however the results of some workflows such as the [Density Counting workflow]({{site.baseurl}}/documentation/counting/counting.html) cannot be exported in some of these formats (**hdf5 file format is supported by all workflows**).

![](screenshots/batch2_zoomed.png)

After clicking on the **Export all** button, ilastik begins batch processing all images, and writes the resulting classification result to the specified output files. When the default settings are used, the output files are stored as hdf5 files in the same directory where the input file is located.
The exported files have the same name with a "export.h5" suffix.

The exported ".h5" files, contain the resulting prediction as a multidimensional dataset inside the file. Furhter details on this versatile file format (that is easibly readable from Matlab and Python) can be found <a href = "http://www.h5py.org/docs/"> here</a>.
