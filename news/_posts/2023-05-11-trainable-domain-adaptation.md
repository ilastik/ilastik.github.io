---
title: "new workflow in beta: Trainable Domain Adaptation"
---

For [beta version][beta] `1.4.1b1`, we have added a new workflow that combines shallow and deep learning approaches.
Check out the [documentation for the Trainable Domain Adaptation Workflow][tda].

In this workflow the [Pixel Classification][pixelclass] approach is combined with pre-trained convolutional neural networks (CNNs) for specific tasks.
Currently, pre-trained networks are available for mitochondria segmentation in EM, and generic em boundary enhancement in EM, both for 2D and 3D data.
The networks are hosted on [BioImage Model Zoo][bioimageio], and are available automatically from within ilastik in this workflow.


[beta]: {{site.baseurl}}/download.html#beta
[bioimageio]: https://bioimage.io
[pixelclass]: /documentation/pixelclassification/pixelclassification.html
[tda]: {{site.baseurl}}/documentation/tda/tda.html
