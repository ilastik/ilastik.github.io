---
layout: documentation
title: Layers 
tagline: 
category: "Documentation"
group: "basic-documentation"
weight: 30
---
#Layers 

Most applets show a widget as below in the lower left corner:

<a href="screenshots/layers.png" data-toggle="lightbox"><img src="screenshots/layers.png" class="img-responsive" /></a>

Shown is a list of _layers_. These layers show datasets with the same
extent as the original data (Input Data), from which they were derived.
Examples are predicted pixel probabilities or segmentation.

Layers can be thought of as a stack of transparencies.
In the above example, the _Input Data_ layer comes first. On top of that,
we overlay - in this order -
_Prediction for Label 1_,
_Segmentation (Label 1) _,
_Uncertainty_, and
_Labels_.

<a href="screenshots/eye_active.png) (visible" data-toggle="lightbox"><img src="screenshots/eye_active.png) (visible" class="img-responsive" /></a>
<a href="screenshots/eye_inactive.png) (invisble" data-toggle="lightbox"><img src="screenshots/eye_inactive.png) (invisble" class="img-responsive" /></a>
shows whether this layer is visible or not. Invisible
layers are ignored.

Each layer's transparency is indicated by the gray bar below its name,
and the opacity (alpha) is shown.
100% means a fully opaque layer, while 0% means a completely transparent
layer. The amount of transparency can be changed by clicking the gray bar.

<a href="screenshots/layers_00.png" data-toggle="lightbox"><img src="screenshots/layers_00.png" class="img-responsive" /></a>
Layers can also be _reordered_ to change their position in the stack.
To do this, first highlight a layer by single click (in the example above,
the _Input Data_ layer is highlighted), then use the up/down arrows on the
lower right.

<a href="screenshots/layers_01.png" data-toggle="lightbox"><img src="screenshots/layers_01.png" class="img-responsive" /></a>
To export the data that is shown by the currently _highlighted_ layer,
press this button.

<a href="screenshots/layer-contextmenu.png" data-toggle="lightbox"><img src="screenshots/layer-contextmenu.png" class="img-responsive" /></a>

Alternatively, a layer's contextmenu (right click) can be used to access the
same layer export functionality.

The export dialog is described in
the [data export]({{site.baseurl}}/documentation/basics/export.html) section.

