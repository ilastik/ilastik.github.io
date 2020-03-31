---
title: Voxel Segmentation Workflow (beta)
tagline: Voxel Segmentation with Active Learning
category: "Documentation"
group: "workflow-documentation"
weight: 1
---
# Voxel Segmentation Workflow

The voxel segmentation workflow is currently included in ilastik as a beta version (as of 1.4.0).
In order to access this workflow, supply the `--hbp` command line flag when starting ilastik.

## What it is and why you need it

This workflow allows you to segment structures like cells or synapses in 3D image volumes and 2D images with a minimal amount of annotations. 
This workflow introduces an interactive labeling pipeline, where the labels produced by the annotator are immediately and seamlessly used to improve the predictor, which is then used to speed up further annotation. 
The main algorithm, known as Active Learning, was presented in [this paper](http://openaccess.thecvf.com/content_iccv_2015/papers/Konyushkova_Introducing_Geometry_in_ICCV_2015_paper.pdf) by K. Ksenia.
This workflow can facilitate the reconstruction of complex 3D structures from any type of [image stacks](https://arxiv.org/abs/1606.09029), ranging from electron microscopy, through light microscopy, to MRI and CT scans.


## How it works


The first stage of this workflow computes an over-segmentation of the input volume using supervoxels. 
On this over-segmentation, you annotate a small number of voxels in randomly chosen slices of the input volume, with labels covering the desired classes. 
These annotations are then used to train an initial classifier. 
You can switch see the result of this initial classifier by pressing the _live-update_ button.
When using 3D data, the active learning algorithm proposes slices requiring annotation and guides you through the labeling process by pinpointing a small number of voxels to be annotated.
The selection of the slice and the voxels to be annotated is done in such a manner as to optimise the performance gain of the classifier and minimise manual intervention. 
The idea is to annotate the highlighted areas to train an improved classifier.
The segmentation result is updated interactively. 
This process of annotation and re-segmentation is repeated until the segmentation results become satisfactory.

## How to use it

To demonstrate the usage of this workflow, segmentation of mitochondria is presented as an application. 
The input is a small portion of the electron microscopy volume of rat neural tissue (data from Pascal Fua’s CV lab, EPFL). 
Segmentation of the given input volume involves the following steps:

#### Load the data:
Start the Voxel Segmentation Workflow and load the input volume. 
You can move across the volume using the arrow buttons associated with x,y, and z-axes. 
After loading the data, the user interface will look like this:

<a href="./fig/data_input_applet_raw.png" data-toggle="lightbox"><img src="./fig/data_input_applet_raw.png" class="img-responsive" /></a>


#### Compute supervoxels:
Use the [SLIC](https://infoscience.epfl.ch/record/149300) (Simple Linear Iterative Clustering) applet to break the input volume into supervoxels. 
SLIC generates a supervoxel based over-segmentation by clustering voxels on basis of their color similarity and proximity. 
You can fine-tune the resulting divisions by varying the hyper-parameters involved. 
Let’s go through the controls of this applet from top to bottom:

- _n_segments_: Number of supervoxels that the input volume will be divided into. 
Higher value results in finer partitioning of the input volume.

- _Compactness_: Control the compactness of a supervoxel. 
A higher value emphasizes more spatial proximity resulting in more compact clusters.

- _max_iter_: Number of iterations used to compute the supervoxel clusters. 
The algorithm typically converges in 4 to 10 iterations.

Fine-tune the values of n_segments and Compactness to yield a near-perfect over-segmentation of the input volume. 
Here are the examples to supervoxel-based over-segmentation results with different values of hyper-parameters.

<a href="./fig/slic_500_p4.png" data-toggle="lightbox"><img src="./fig/slic_500_p4.png" class="img-responsive" /></a>
<a href="./fig/slic_1900_p4.png" data-toggle="lightbox"><img src="./fig/slic_1900_p4.png" class="img-responsive" /></a>
<a href="./fig/slic_1900_p2.png" data-toggle="lightbox"><img src="./fig/slic_1900_p2.png" class="img-responsive" /></a>

Enable result layers for viewing by clicking the _eye_ icon for the input, super-pixel boundaries, and the over-segmentation output. 
The best way to fine-tune supervoxel generation is to view the super-pixel boundaries by overlaying on the input and then adjust parameters to ensure that the supervoxel boundary is well aligned with respect to the boundaries of the objects that we would like to segment out.
Make sure that supervoxels don't connect different neighboring structures you want to segment.


#### Feature selection:
This step is similar to the Pixel Classification Workflow. 
The details can be found [here]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html).


#### Interactive labeling and training:

- Annotate a small number of voxels in the input volume, with labels covering all the desired classes. 
The labeling can be done in a similar way, as explained in [Pixel Classification Workflow](https://www.ilastik.org/documentation/pixelclassification/pixelclassification.html). 
Since the input is a volume, the labeling can be repeated on a few randomly chosen slices as well. 
Here is an example of annotation.

<a href="./fig/annotate_init.png" data-toggle="lightbox"><img src="./fig/annotate_init.png" class="img-responsive" /></a>
<a href="./fig/annotate_init_supervoxels_overlaid.png" data-toggle="lightbox"><img src="./fig/annotate_init_supervoxels_overlaid.png" class="img-responsive" /></a>

- After annotating a few voxels, switch Live update on (using the _Live Update_ button). 
This trains an initial classifier and results in a first prediction. 
Training and label update follows similar steps to the ones mentioned in [Pixel Classification Workflow]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html). 
The differences come in the following aspects. 
After each live update, some regions in the segmentation outputs will be highlighted with topUncertainty. 
These are the regions that are most uncertain as per the classifier decision, and therefore should be given more emphasis in the next step of labeling. 
Regions with maximum uncertainty are highlighted with a cyan pattern and outline.
When working with 3D data, clicking on “suggest slice,” will change to the slice with maximum uncertainty. 
Add new labels so as to cover the most uncertain regions. 
Alongside this, the regions that got misclassified should also be labeled. 
After modifying the labels turn on live update again to generate improved segmentation results. 
The process of annotation and re-segmentation can be repeated until the segmentation results become satisfactory. 
Examples of first prediction, topUncertainty regions, label update on suggested slices, and the final segmentation results are shown below.

1. First prediction
<a href="./fig/first_prediction.png" data-toggle="lightbox"><img src="./fig/first_prediction.png" class="img-responsive" /></a>
2. Annotation on the first suggested slice
<a href="./fig/first_prediction_label_0.png" data-toggle="lightbox"><img src="./fig/first_prediction_label_0.png" class="img-responsive" /></a>
3. Find the next suggested slice
<a href="./fig/first_prediction_suggested_slice_1.png" data-toggle="lightbox"><img src="./fig/first_prediction_suggested_slice_1.png" class="img-responsive" /></a>
4. Annotation on the second suggested slice
<a href="./fig/first_prediction_label_1.png" data-toggle="lightbox"><img src="./fig/first_prediction_label_1.png" class="img-responsive" /></a>
5. Second prediction
<a href="./fig/second_prediction.png" data-toggle="lightbox"><img src="./fig/second_prediction.png" class="img-responsive" /></a>
6. Final segmentation
<a href="./fig/final_segmentation.png" data-toggle="lightbox"><img src="./fig/final_segmentation.png" class="img-responsive" /></a>


#### Exporting results:

To export the results, follow the standard ilastik procedure demonstrated [here]({{site.baseurl}}/documentation/basics/export.html).


References:

Konyushkova K, Sznitman R, Fua P., Introducing Geometry in Active Learning for Image Segmentation. international conference in Computer Vision, December 2015.

Konyushkova K, Sznitman R, Fua P., Geometry in Active Learning for Binary and Multi-class Image Segmentation, Computer Vision And Image Understanding (CVIU), 182, 1-16, May 2019.
