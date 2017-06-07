---
layout: documentation
title: Common Problems 
tagline: Tips, tricks and workarounds
category: "Documentation"
group: "basic-documentation"
weight: 7
---
# Common problems, their solutions, tips, tricks and workarounds.

If you are experiencing a problem with ilastik which we haven't yet described below, please [let us know]({{site.baseurl}}/community.html)! 
If your problem is already described, [tell us anyway]({{site.baseurl}}/community.html) and we'll adjust our priority list.

#### 1) My dataset is loaded, but the image looks transposed or it's stacked along "z" instead of "t"
This can be fixed by editing the dataset properties, as described [here]({{site.baseurl}}/documentation/basics/dataselection#properties).

#### 2) I am trying to load a multipage tiff file, but something is going wrong
We keep working on making all multipage tiffs load seamlessly. If your use case is still not fixed, there are two workarounds:

* Try the [Fiji Import/Export plugin]({{site.baseurl}}/documentation/fiji_export/plugin) and export your data to ilastik favorite hdf5 format

* Export your data as a sequence of tiffs rather than a single tiff multipage tiff file.

#### 3) Navigation is slow/lagging
ilastik works best if the input data is in the hdf5 format. Here are some options:

* Use the [Fiji Import/Export plugin]({{site.baseurl}}/documentation/fiji_export/plugin) and export your data to ilastik favorite hdf5 format

* Use ilastik's Data Conversion workflow

* In the [Dataset Properties Editor]({{site.baseurl}}/documentation/basics/dataselection#properties) change the "storage" option to "Copied to project file"

* Write a custom script in Python using the h5py library
