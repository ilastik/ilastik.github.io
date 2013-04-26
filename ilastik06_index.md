---
layout: ilastik06
title: ilastik 0.6 - Overview
---

ilastik is a simple, user-friendly tool for **image classification and
segmentation** in up to three spatial and one spectral dimension. Using it
requires no experience in image processing.

ilastik has a convenient mouse interface for labeling an **arbitrary number
of classes** in the images. These labels, along with a set of generic
(nonlinear) image features, are then used to train a Random Forest classifier.
In the **interactive training** mode, ilastik provides real-time feedback of
the current classifier predictions and thus allows for targeted training and
overall reduced labeling time. In addition, an uncertainty measure can guide
the user to ambiguous regions of the data. Once the classifier has been trained
on a representative subset of the data, it can be exported and used to
**automatically process** a very large number of images.

The features are computed in the **full 2D/3D/4D pixel neighborhoods**,
depending on the available data. While the provided set of features includes
popular color, edge and texture descriptors, the **plug-in functionality**
allows advanced users to add their own problem-specific features. Feature
computation and classifier prediction are **multi-threaded** and fully
exploit modern multi-core machines. 

So far, we have used ilastik successfully on applications from the
neurosciences (segmentation of EM images), systems biology (high throughput
screening experiments) and industrial quality control. 
