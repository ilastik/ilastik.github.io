---
title: Batch Processing
tagline:
category: "Documentation"
group: "basic-documentation"
weight: 6
---
# Batch Processing

In the machine learning based ilastik workflows such as the [Pixel Classification Workflow]({{site.baseurl}}/documentation/objects/objects.html), the user interactively trains a classifier on a representative set of images.
After that training step, the generated classifier can be applied to more data by using batch processing.

## Example Usage (Pixel Classification)

The following tutorial demonstrates the batch prediction for the [pixel classification workflow]({{site.baseurl}}/documentation/objects/objects.html).
The procedure is the same in the other workflows (with the exception of Carving, where there is no batch processing available).

### Configuring Output File Names

Before getting to the batch processing part, you first have to set up the file export settings.
Batch processing uses the same settings as in the [Prediction Export]({{site.baseurl}}/documentation/basics/export#settings) step.
Here it is crucial to use the _magic placeholders_, denoted by curly braces (e.g. `{nickname}`), to ensure a unique export filename for each file.
Also make sure to configure the export source, file format, and other properties.

### Selecting files

You can add files either by drag-and-drop from your file browser, or use the **Select Raw Data Files...** button.

<a href="screenshots/batch_processing_01.png" data-toggle="lightbox"><img src="screenshots/batch_processing_01.png" class="img-responsive" /></a>

When clicking on the **Select Raw Data Files...** button, you can choose between adding single or multiple files from the File selection dialog.


The next step is the actual batch processing itself.
In the **Batch Prediction Output Locations** applet, the user can configure the output format using the **Choose Settings** button. This allow for example to save the results of the workflow as `.png` images rather than `.tiff` or `.h5` files. For novice users the default settings should be fine, however the results of some workflows such as the [density counting workflow]({{site.baseurl}}/documentation/counting/counting.html) cannot be exported in some of these formats (**hdf5 file format is supported by all workflows**).

<a href="screenshots/batch2_zoomed.png" data-toggle="lightbox"><img src="screenshots/batch2_zoomed.png" class="img-responsive" /></a>

After clicking on the **Export All** button, ilastik begins batch processing all images, and writes the resulting classification result to the specified output files. When the default settings are used, the output files are stored as hdf5 files in the same directory where the input file is located.
The exported files have the same name with a `export.h5` suffix.

The exported `.h5` files, contain the resulting prediction as a multidimensional dataset inside the file. Further details on this versatile file format (that is easily accessible from Matlab and Python) can be found [here](http://docs.h5py.org/).
