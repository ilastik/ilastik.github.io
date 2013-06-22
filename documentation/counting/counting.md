---
layout: documentation
title: Counting
tagline: Interactive Counting
category: "Documentation"
group: "workflow-documentation"
---
# Counting
## How it works, what it can and cannot do

The purpuse of this workflow is counting the number of objects in crowded scenes such as cells in microscopic images. 
When the density of objects is low it is possible to count objects by segmenting isolated individuals as in the <a href = "../objectClassification"> Object Classification</a> workflow. However, as the density of objects increases the latter approach underestimates the true counts due to undersegmentation errors. 

This workflow offers a supervised learning strategy to object counting which is more robust to overlapping instances. The algorithms that this workflow implements are appropriate for counting small, **overlapping objects with similar appearence** (importantly a low variability in size) which are homegeneusly distributed over an uniform background. Specifically, these algorithms learn a **continuous object density** whose integral over any large image region gives the **count of objects** in that region. 

To ease the burden on the user, we focused on minimizing the amount of input that has to be provided. The workflow input are user given markers (see example below) in the form of dots (red) for the object instances and brushstrokes for irrelevant background (green). A pixelwise mapping between local texture features and the object density is learned from these markers. This workflow offers the possibility to interectively refine the learned density by:

* Placing more markers for the foreground and background 
* Monitoring the object counts in image regions
* Constraining the number of objects in image regions 



## 1. Input Data
The user can supply either images (e.g. \*.png, \*.jpg and \*.tif) directly or pass hdf5 datasets. The image import procedure is detailed in LINK TO GENERAL ILASTIK SECTION". Please note that the current version of the Counting module is limited to handling 2D data, for this reason hdf5-datasets with a z-axis are not accepted. Only the training images requiring manual labeling have to be added in this way, the full prediction on a large dataset can be done via Batch Processing.

## 2. Sizing up the objects

IMAGE: Showing different controls for labeling with the brush
Similarly to the other modules, annotations are are done by painting while looking at the raw data.
Providing background strokes works exactly like in Pixel Classification and has the same goal of classifying, foreground marking is slightly different, evident in the way the cursor behaves. 


To give the user a better understanding of the impact of his labels, we provide a preview layer: every **dot** marker is smoothed via a gaussian filter according to the global **Sigma** value, the resulting shapes should cover the training examples as well as possible.

IMAGE: Good sigma/dot, bad sigma/dot


## 3. Interactive refinement
Using LiveUpdate
Place Observerboxes
## Dots and stripes
Dots have to be placed close to the center
Cursor has the size of the currently selected Sigma

Most importantly dots on overlapping cells, otherwise training data incorrect.
Background: broad strokes, just marking unimportant stuff

Use boxes to get general idea of quality




## 4. Algorithm
### Random Regression Forest
2 different regressors are supplied in our framework.
Random Forest is fast and included in scikit-learn, which is a dependency for ilastik.
Requires more labels to give correct results over bigger dataset.
Good at handling background labels due to non-linearity




### Support Vector Machine
Requires Gurobi
Slower
Better generalization
Can offer additional type of label via Box constraints
-Box constraints not strict
#Box constraints
Box constraints offer an easy way to provide counts for a region, while not having to label every instance individually.




## Regression Parameters
We expose the most important and well-known parameters for our algorithms to the user, 
which consist of the following:
C: How much impact should individual and box errors do compared to w itself, this will likely only change results if you set C to low values.
epsilon: The amount of error that will be tolerated for individual pixels, this regularizes the result. 
though the defaults should already create good results.





## Exporting results
Possible to save the regressor
Will be loaded again, can do prediction directly if parameters and labels untouched
Can also save prediction itself
If you want to export the results for a single image, use exportLayerDialog.

##Batch prediction
For large-scale prediction, first train regressor, then add input images, then press export all.




