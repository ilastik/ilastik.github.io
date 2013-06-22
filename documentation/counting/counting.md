---
layout: documentation
title: Counting
tagline: Interactive Counting
category: "Documentation"
group: "workflow-documentation"
---
# Interactive Object Counting
## How it works, what it can and cannot do

The purpuse of this workflow is counting the number of objects in crowded scenes such as cells in microscopic images. 
When the density of objects is low it is possible to count objects by segmenting isolated individuals as in the <a href = "../objectClassification"> Object Classification</a> workflow. However, as the density of objects increases the latter approach underestimates the true counts due to undersegmentation errors. 

This workflow offers a supervised learning strategy to object counting which is more robust to overlapping instances. It is appropriate for counting small, **overlapping objects with similar appearence** (importantly a low variability in size) which are homegeneusly distributed over an uniform background. In orderd to avoid the difficult task of segmenting individual objects, the workflow algorithm learns a **continuous object density** whose integral over any large image region gives the **count of objects** in that region. This approach was first introduced in ref GIVEREFERENCE.

To ease the burden on the user, we focused on minimizing the amount of input that has to be provided. The workflow input are user given markers (see example below) in the form of dots (red) for the object instances and brushstrokes for irrelevant background (green). A pixelwise mapping between local texture features and the object density is learned from these markers. This workflow offers the possibility to interectively refine the learned density by:

* Placing more markers for the foreground and background 
* Monitoring the object counts in image regions
* Constraining the number of objects in image regions 


## 1. Input Data
The user can provide either images (e.g. \*.png, \*.jpg and \*.tif) directly or pass hdf5 datasets. The image import procedure is detailed in LINK TO GENERAL ILASTIK SECTION". Please note that the current version of the Counting module is limited to handling **2D data**, for this reason hdf5-datasets with a z-axis are not accepted. Only the training images requiring manual labeling have to be added in this way, the full prediction on a large dataset can be done via Batch Processing.

## 2. Feature Selection
Assuming the user has already created or loaded an existing ilastik project and added a dataset, as the other learning based workflows the first step for the user is to define the some features. Empirically we found that the same features of the pixel classification workflow (in particular Texture, Edge and Color) provide good performance in case of blob like objects such as cell.
It is appropriate to match the scale of the object with the size of the features. For further details please refer to LINKME.

## 3. Interactive counting
Similarly to the other modules, annotations are are done by painting while looking at the raw data and the result of the algorithm can be interactively refined while beeing in **live-update** mode. However, unlike the Pixel Classification workflow, where only user brushes are supported, LINK TO THOSE, in the Counting workflow the user has a broader range of possible interactions which can be grouped into two categories:

* **Dotting** the object instances and **Brushing** over the background 
* **Boxing** image regions




### Dotting/Brushing Interaction Mode
This is tipically the interaction with the core workflow. The purpose of this interaction is to provide the classifier with examples for the object density and examples for the background. 

To begin placing a dot just click on the **RED** foreground label. Objects instances have to be marked by user dots which have to be placed close to the center of the objects. Given the dotted annotations, a smooth training density is derived by placing a Gaussian at the location of each user annotation. The size of the gaussian is controlled by the parameter **Sigma** which should roghly match the object size. In order to decide an appropriate sigma when clicking on this parameter you will see the that the size of the **crosshair-cursor** changes accordingly. NOTE: big Sigmas can heavily impact the required computation time, consider a to use a different approach if this parameter has to be chosen larger than 4-5.

![](fig/dotting2.png)

FIGURE FOR BACKGROUND SIDE BY THE ONE FOR THE DOTS


To give the user a better understanding of the impact of his labels, we provide a preview layer: every **dot** marker is smoothed via a gaussian filter according to the global **Sigma** value, the resulting shapes should cover the training examples as well as possible.

IMAGE: Good sigma/dot, bad sigma/dot


Background labelling happens exactly as in the Pixel Classification workflow LINKME. To activate this interction click on the **GREEN** background label and give broad strokes, marking unimportant stuff or regions where the predicted density should be close to 0. You can set the size of the brush ...


IMAGE: Showing different controls for labeling with the brush

### Boxing Interaction Mode

Use boxes to get measure the object count over the region and get a general fealing for the quality of the prediction.
![](fig/res-box2.png)

FIGURE FOR BACKGROUND SIDE BY THE ONE FOR THE DOTS

Side by side boxes on the raw data and boxes on the density

## 3. Interactive refinement
Using LiveUpdate
Place Observerboxes



## 4. Algorithms
Two different regression algrotihms are currently supportd by the Counting workflow depending on the availability of CPLEX on the machine where ilastik is intalled. We expose the most important and well-known parameters for our algorithms to the advanced user, details are given below. 

### Random Forest
This approach uses a Random Regression Forest as regression algorithm. 
In general it requires more labels to give correct results over several images, however it more robust to  less homogeneus background.

The implementeation of the random regression forest is based on <a href = "http://scikit-learn.org/stable/"> sklearn</a> similar to ref GIVE REFERENCE
#### Advanced parameters

### Support Vector Regression
Requires Gurobi
Slower
Better generalization
Can offer additional type of label via Box constraints
-Box constraints not strict
#### Box Constraints
Box constraints offer an easy way to provide counts for a region, while not having to label every instance individually.

#### Advanced parameters
C: How much impact should individual and box errors do compared to w itself, this will likely only change results if you set C to low values.
epsilon: The amount of error that will be tolerated for individual pixels, this regularizes the result. 
though the defaults should already create good results.





## 4. Exporting results
Possible to save the regressor. Will be loaded again, can do prediction directly if parameters and labels untouched
Can also save prediction itself. If you want to export the results for a single image, use exportLayerDialog.



## 5. Batch Processing
For large-scale prediction, first train regressor, then add input images, then press export all.

## 6. References

