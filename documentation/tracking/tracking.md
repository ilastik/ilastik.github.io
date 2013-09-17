---
layout: documentation
title: Tracking (Automatic and Manual)
tagline: Tracking
category: "Documentation"
group: "workflow-documentation"
---
# Automatic Tracking and Manual Tracking
## Overview and Scope

Ilastik provides two different tracking workflows, the manual/semi-automatic tracking and the automatic tracking.
While the fully [**automatic tracking workflow**](#sec_automatic)
is used to track multiple (dividing) objects in presumably big datasets, the purpose of the [**manual tracking
workflow**](#sec_manual) is to track objects *manually* from previously detected objects. 
The latter may be useful for high-quality tracking of small datasets or 
ground truth acquisition. To speed up this process, sub-tracks may be generated automatically for trivial
assignments such that the user only has to link objects where the tracking is ambiguous.

Although they are different workflows and The automatic and manual tracking workflows share a few 
components (*applets*) for preprocessing the dataset;
the only difference is the actual tracking applet. 
This tutorial describes those shared applets for both workflows simultaneously before providing documentation for the
specific manual/semi-automatic or (fully) automatic tracking applets.

**Please note that the _automatic_ tracking workflow only works on machines where CPLEX is installed
additional to ilastik. Instructions on how to install CPLEX are given [here](../../download.html).**

The manual tracking and automatic tracking workflows both build on the results of the
<a href="../pixelClassification/">Pixel Classification workflow</a>. 
From the objects detected in this workflow, tracks (object identities linked over time) are either created by the user
in a semi-automatic fashion or by the automatic tracking algorithm, respectively,
optionally allowing for object divisions
(e.g. cell mitosis). 


![](./fig/00_overview.jpg)

Just as in the Pixel Classification, both 2D(+time) and 3D(+time) data may be processed. 
To learn about how to navigate in temporal data ( *scroll through space or time, 
enable/disable overlays, change overlay capacity, etc.* ) please read the <a
href="../navigation/">Navigation guide</a>.

We will now step through a tutorial how to track proliferating cells both in 2D+time
and 3D+time data, which are both provided in the 
<a href="../../download.html">Download</a> section. 
The user has to decide already on the startup of ilastik whether he/she wants to *manually* track
objects or the *automatic* tracking object should be used. Depending on this choice, this tutorial will
diverge later.

Before starting the tracking workflows, the data has to be segmented into fore- and 
background. The tutorial uses the dataset 
`mitocheck_94570_2D+t_01-53.h5` kindly provided by the
<a href="http://www.mitocheck.org">Mitocheck project</a>,
which is available in the <a href="../../download.html">Download</a> section. 

## 0. Segmentation:
The tracking workflows are based on the results of the 
<a href="../pixelClassification">Pixel Classification workflow</a>, where the
user segments foreground objects (e.g. cells) from background by defining two
labels and providing examples through brush strokes. 
Please find a detailed
description of this workflow 
<a href="../pixelClassification">here</a>, and a descand Manual Trackingseries dataset is provided <a href="../inputOutput">here</a>.

In this example, we paint some background
pixels with Label 1 (red by default) and cell nuclei are marked with Label 2 
(green by default). When happy with the live segmentation, the user applies
the learned model to the entire dataset by exporting the results in the **Prediction Export** applet 
to (preferably) an hdf5 file such as  
`mitocheck_94570_2D+t_01-53_resultas.h5`. 
To directly showcase the tracking workflows, we provide this file with the data.

![](./fig/02_training.jpg)

Now, one of the tracking workflows (Manual Tracking or Automatic Tracking, if [CPLEX is installed](../../download.html) ) 
can be launched from the start screen of ilastik
by creating a new project.

![](./fig/04_start-workflow.jpg)

These two workflows comprise the following applets:

## 1. Input Data:
To begin, the raw data and the prediction maps (the results from the Pixel Classification workflow or segmented images from
other sources) 
need to be specified in the respective tab. In particular, the file 
`mitocheck_94570_2D+t_01-53.h5` 
is added as **Raw Data** and the dataset in
`mitocheck_94570_2D+t_01-53_results.h5`
is loaded as **Prediction Maps**.

The tracking workflow expects the image sequence to be loaded as a time-series data containing a time axis;
if the time axis is not automatically detected (as in hdf5-files), the axes tags may be modified in a dialog 
when loading the data (e.g. the `z` axis may be interpreted as `t` axis by replacing `z` by `z` in this dialog). 
Please read the <a href="../inputOutput">Input/Output guide</a> for further tricks how to load images as time-series
data.


![](./fig/05_load-raw.png)

![](./fig/06_load-predictions.png)

After specifying the raw data and its prediction maps, the latter will be smoothed
and thresholded in order to get a binary segmentation, 
which is done in the **Thresholding and Size Filter** applet:

## 2. Thresholding and Size Filter:
First, the channel of the prediction maps which contains the foreground 
predictions has to be specified. 
For instance, if in the Pixel Classification workflow,
the user chose Label 1 (red by default) to mark foreground, **Channel** will be 0, 
otherwise, if Label 2 (green by default) was taken as the foreground label, then Channel
takes value 1. Thus, we choose the Input Channel to be 1 in this tutorial. If the correct 
channel was selected, the foreground objects appear in white after pressing **Apply**:

![](./fig/07_thresholding-01.jpg)

The prediction maps are now storing a probability for each single pixel/voxel to be foreground. 
These probabilities may be smoothed over the neighboring probabilities with a Gaussian filter,
specified by the **Sigma** values (allowing for anisotropic filtering).
The resulting probabilities are finally **thresholded** at the value specified. The default
values for the smoothing and thresholding should be fine in most of the cases. 
Please consult the documentation of the
<a href="../objects">Object Classification workflow</a>
for a more detailed description of this applet, including an explanation of the **Two thresholds** 
option.

Note that, although the tracking workflows expect prediction maps as input files, nothing prevents
the user from loaded (binary) segmentation images instead. Since the smoothing filter and thresholding
are applied also to those binary images, the user should choose Sigmas of 0.1 to keep their original 
segmentation images in the further process of the workflow.

Finally, objects outside the given **Size** bound are filtered out for this and the following
steps.

***Please note that all of the following computations and the tracking will 
be invalid (and deleted) when parameters in this step are changed.***

In the following applets, connected groups of pixels will be treated as individual objects.


## 3. Object Extraction:
This is the most computation intensive preprocessing step of the tracking workflows. 
Note that dependent on
the size of the datasets, this step might take minutes to hours.

All the user has to do here is to press the **Calculate Features** button. Neighboring
pixels/voxels are then grouped (in 2D or 3D, respectively) to define individual objects,
those objects are assigned independent and unique identities (indicated by distinct random colors
in the **LabelImage** overlay), and features of the objects (e.g. region centers)
are computed.

![](./fig/09_object-extraction-results.jpg)

When the computation was successful, the user can start with the actual tracking
of the detected objects. 

## 4. Tracking:
The remainder of this tutorial first discusses the tracking in case the **manual tracking
workflow** was started, and then reviews the tracking applet of the [**automatic tracking workflow**](#sec_automatic).

Both tracking workflows can process 2D+time (`txy`) as well as 3D+time (`txyz`) datasets. This
tutorial guides through a 2D+time example, and a 3D+time example dataset is provided and discussed
[at the end of the tutorial](#sec_3d).

<a name="sec_manual">&nbsp;</a>
### 4.1 Manual Tracking:

The purpose of this workflow is to manually link detected objects in consecutive time steps
to create tracks (trajectories/lineages) for multiple (possibly dividing) objects. All
objects detected in the previous steps are indicated by a yellow color.
While undetected objects may not be recovered to date, the user can correct for the following 
kinds of undersegmentation errors: Merging (objects merge into one detection and later split again), 
and misdetections (false positive detections due to speckles or low contrast).

Note that -- as in every workflow in ilastik -- displaying and updating the data is much faster when
zooming into the region of interest.

#### Tracking by Clicking or by Semi-Automatic Procedure
To **start a new track**, the respective button is pressed and the track ID
with its associated color (blue in the example below) is displayed as **Active Track**. Then,
each object which is (left-) clicked, is marked with this color and assigned to the current track.
Note that the next time step is automatically loaded after adding an object to the track 
and the logging box displays the successful assignment to the active track.
Typically, we start with an arbitrary object in time step 0, but any order is fine.

![](./fig/10_manual-tracking-start-track.jpg)

In theory, one could now proceed as described and click on each and every object in the following
time steps which belongs to this track. However, this might be rather cumbersome for the user, especially
when dealing with a long image sequence. Instead, the user may use a semi-automatic procedure for the
trivial assignments, i.e. assignments where two objects in successive time frames distinctly overlap in space.
This **semi-automatic tracking** procedure can be started by right-clicking on the object of interest:

![](./fig/11_manual-tracking-right-click.jpg)

The semi-automatic tracking will continue assigning objects to the active track until a point is reached
where the assignment is ambiguous. Then, the user has to decide manually which object to add to the
active track, by repeating the manual or semi-automatic assignments described above.
The track is complete when the final time step is reached. 
To start a new track, one navigates back to the first timestep (either by entering `0` in the time
navigation box in the lower right corner of ilastik, or by using `Shift` + `Scroll Up`).
Then, the next track may be recorded by pressing **Start New Track**.

#### Divisions
In case the user is tracking **dividing objects**, e.g. proliferating cells as in this tutorial,
divisions have to be assigned manually (the semi-automatic tracking will stop at these points). To do so,
the user clicks the button **Division Event**, and then -- in this order -- clicks on the 
parent object (mother cell) followed by clicks on the two children objects (daughter cells) *in the next
time step* (here: green and red). As a result, a new track is created for each child. The connection between the parent 
track and the two children tracks is displayed in the **Divisions** list, colored by
the parent object's color (here: blue).

![](./fig/16_manual-tracking-division4.jpg)

Now, the first sub-lineage may be followed (which possibly divides again, etc.), and when
finished, the user can go back to the division event to follow the second sub-lineage (the respective
track ID must be selected as **Active Track**). To do so, double clicking on the
particular event in the division list navigates to the parent object (mother cell).
It is useful to check its box in order to indicate already processed divisions.
Note that these sub-lineages may again more efficiently be tracked with the *semi-automatic tracking* procedure 
described above.


#### Supported Track Topology

The following track structure is supported:

- **One object per track per time step**: Each track ID may only appear at most once per time step. To track
another object, the user has to start a new track. 
- **Merging objects**: Due to possible occlusions or undersegmentation resulting
from the Pixel Classification workflow (i.e. two or
more objects are detected as only one object), it is possible to assign multiple track IDs to
one object. For instance, two distinct cells in previous time steps are merging into one detection and 
later splitting again. Then -- in the sequence where the two cells are occluding each other -- the detections
are treated as *Mergers* of two tracks, and the tracks are recovered after the occlusion.
It should be noted that the object is marked with a color randomly chosen from the track IDs of the comprised
objects. By right-clicking on the object, the user may check which track IDs it is assigned to.
- **Misdetections**: It may happen that background is falsely detected as foreground objects. For reasons of
clarity, the user may
mark those objects explicitly as false detections with black color
by pressing **Mark as Misdetection** followed by a click
on the object. Note, however, that untracked objects later would not be exported anyway.
- **Appearance/Disappearance of objects**: Due to low contrast or limited field of view, objects may appear
or disappear. If an object does not have an ancestor or successor in the directly adjacent timesteps, an
appearance or disappearance event, respectively, is evoked. 


#### Advanced Features

Further features in the Manual Tracking applet are:

- **Go to next unlabeled object**: Although the objects may be tracked in an arbitrary order, it is sometimes
useful to automatically jump to the next untracked object, particularly if only few objects are left to track.
The user may then either track the suggested object or mark it as misdetection to get another suggestion for an
object to track next.
- **Window size**: These parameters define the size of the window in which the automatic tracker searches for
overlapping between objects of consecutive time steps. Note that the tracking is faster for smaller window sizes,
however, longer sub-tracks may be achieved by bigger window sizes. For the example datasets, we choose a window
size of 40 pixels along each dimension.
- **Inappropriate track colors**: If the color of the next active track is inapproriate (e.g. it has low contrast
on the user's screen, it may be mixed up with other colors in the proximity of the object of interest, or it
is some already reserved color), the user may just leave this track empty and start another track.
- **Delete label**: False assignments of track IDs can be deleted by right-clicking on the respective object.
The user then has the option, to (i) delete the respective track label from this single object, (ii) delete
the track label in the current and all later time steps, or (iii) delete the track label in the current
and all earlier time steps:
![](./fig/22_manual-tracking-right-click-menu.jpg)


#### Export
To export the manual tracking annotations, follow the instructions [at the end of this tutorial](#sec_export), since 
this procedure is similar to the export of the fully automatic tracking.




#### Shortcuts
To most efficiently use the features described above, there are multiple shortcuts available (a complete documentation
of all available shortcuts can be displayed/modified in `Settings -> Keyboard Shortcuts`):

| Shortcut       | Description   
|:--------------:| -----------------------------
| `Shift + Scroll` | Scroll image through time
| `Ctrl + Scroll`| Zoom
| `s`            | Start new track
| `d`            | Mark division event
| `f`            | Mark false detection
| `q`            | Increment active track ID
| `a`            | Decrement active track ID
| `g`            | Go to next unlabeled object
| `e`            | Toggle manual tracking layer visibility
| `r`            | Toggle objects layer visibility


<a id="sec_automatic"></a>
### 4.2 Automatic Tracking (Chaingraph):

If [CPLEX is installed](../../download.html), it is possible to launch the **automatic tracking workflow (Chaingraph)** 
and -- after the same preprocessing steps as described above -- the user arrives at the automatic tracking applet.

This automatic tracking applet implements the algorithm described in [\[1\]](#ref_chaingraph). The algorithm aims to
link all (possibly dividing) objects over time, where objects may be automatically marked as false positive detections 
(misdetections due to speckles or low contrast) by the
algorithm. Note that -- as of the time of writing -- this algorithm cannot recover missing objects, i.e. objects which 
have not been detected by the previous segmentation step. 
Moreover, the algorithm cannot handle undersegmentation. In other words, 
the identities of previously distinct objects which merge to only one connected component 
may not be recovered after splitting in a later time step.
We will soon extend this workflow to circumvent this latter limitation.

To track the objects detected in the preprocessing steps over all time steps, it is enough to press the **Track** button
(after having checked whether the objects are divisible such as cells or not). After successful tracking, each object (and 
its children in case of divisions) should be marked over time in a distinct random color.

![](./fig/24_chaingraph-tracking-track.jpg)

The algorithm internally formulates a graphical
model comprising all potential objects with relations to objects in their spatial neighborhood in the following time step.
To these objects and relations, costs are assigned defined by the given parameters and an optimizer is called to find
the most probable tracking solution for the model constructed, i.e. it tries to minimize the computed costs.

Although the tracking result should usually be already sufficient with the default values, we now briefly give explanations
for the **parameters** our tracking algorithm uses (see [\[1\]](#ref_chaingraph) for more details). 

| Parameter       | Description
|:---------------:| -------------------------
| Divisible Objects | Check if the objects may divide over time, e.g. when tracking proliferating cells
| Appearance      | Costs to allow one object to appear, i.e. to start a new track other than at the beginning of the time range or the borders of the field of view. High values (&ge;1000) forbid object appearances if possible.
| Disappearance   | Costs to allow one object to disappear, i.e. to terminate an existing track other than at the end of the time range or the borders of the field of view. High values (&ge;1000) forbid object disappearances if possible.
| Opportunity     | Costs for the lost opportunity to explain more of the data, i.e. the costs for not tracking one object and treating it as false detections. High values (&ge;1000) lead to more tracks (but could also include the tracking of noise objects).
| Noise rate      | The estimated rate of false detections coming from the segmentation step. Small values (&asymp;0.01) treat every detected object as a true detection, if possible.
| Noise weight    | The costs to balance a detected object against transitions. High values (&ge;100) treat most objects as true detections if the noise rate is set to a small value (&asymp;0.01).
| Optimality Gap  | The guaranteed upper bound for a solution to deviate from the exact solution of the tracking model. Low values (&le;0.05) lead to better solutions but may lead to long optimization times. Higher values (&ge;0.1) speed up optimization time but lead to approximate solutions only.
| Number of Neighbors | Number of neighbors to be considered as potential association candidates. Less neighbors speed up optimization time, but might have negative impact on tracking results. A reasonable value might be 2 or 3.
| Timeout in sec.  | Timeout in seconds for the optimization. Leave empty for not specifying a timeout (then, the best solution will be found no matter how long it takes).


Furthermore, a **Field of View** may be specified for the tracking. Restricting the field of view to less time steps 
or a smaller volume may lead to significant speed-ups of the tracking.

In **Data Scales**, the scales of the dimensions may be configured. For instance, if the resolution of the 
pixels is (dx,dy,dz) = (1&mu;m,0.8&mu;m,0.5&mu;m), then the scales to enter are (x,y,z)=(1,1.25,2).

To export the tracking result for further analysis, the user can choose between different options described next.



<a name="sec_export">&nbsp;</a>
## 5. Export:
To export the manual tracking, the user may choose between the following three options, allowing for maximal
flexibility to adopt the results to the format needed for the next step in the user's process:

* **Export as tif**: By pressing the **Export Results as tif...** button, an image sequence is created where 
   each **lineage** has the same label, i.e. starting with unique IDs in the first time step for each object (pixelwise),
   each successor
   as well as possible sub-lineages (e.g. daughter cells) are indicated with the same ID. Note, however,
   that *Mergers* get only one of their comprised track IDs assigned.

* **Export as h5**: Another option is to export the manual tracking as a set of hdf5 files, one for 
   each time step, containing pairwise events between consecutive frames (appearance, disappearance, move,
   division, merger). In each of these hdf5 files (except the one for the first time step), detected events
   between object identifiers (stored in the volume `/segmentation/labels`) are stored in the following format:

   | Event      | Dataset Name | Object IDs 
   |:----------:|:------------:| -------------------------
   | Move      | `/tracking/Moves` | `from (previous timestep), to (current timestep)`
   | Division | `/tracking/Splits` | `ancestor (previous timestep), descendant (current timestep), descendant (current timestep)`
   | Appearance | `/tracking/Appearances` | `object id appeared in current timestep`
   | Disappearance | `/tracking/Disappearances` | `object id disappeared in current timestep`
   | Merger | `/tracking/Mergers` | `object_id number_of_contained_objects` 


We would recommend the methods described above, but additionally, the results of the manual/semi-automatic tracking may also 
be accessed via the project file:


* **Process the content of the project file**: The ilastik project file (.ilp) may be opened with any hdf5 dataset viewer/reader, 
   e.g. with `hdfview`. Here, in the Manual Tracking folder, there are the folders `Labels` and `Divisions`. The `Labels`
   folder contains for each time step a list of objects, each of which holds a list of the track IDs which were assigned by the
   user. The `Divisions` dataset contains the list of divisions in the format

        track_id_parent track_id_child1 track_id_child2 time_parent




<a name="sec_3d">&nbsp;</a>
# Tracking in 3D+time Data

One strength of the tracking workflows compared to similar programs available on the web is that 
tracking in 3D+time (`txyz`) data is completely analogous to the tracking in 2D+time (`txy`) data
described above. The data may be inspected in a 3D orthoview and, in the case of manual/semi-automatic tracking
a click on a pixel of the object is 
accepted in any orthoview. Tracked objects are colored in 3D space, i.e. colored in all
orthoviews with the respective track color. 

To get started with 3D+time data, we provide example data in the
<a href="../../Download/">Download</a> section. The file 
`drosophila_00-49.h5` shows 50 time steps of a small excerpt of a developing *Drosophila* embryo, kindly
provided by the 
<a href="http://www.embl.de/research/units/cbb/hufnagel/">Hufnagel Group at EMBL Heidelberg</a>.
A sample segmentation of cell nuclei in this dataset is available in `drosophila_00-49_results.h5`.

For both manual and automatic tracking, the steps of the 2D+time tutorial above may be followed analogously.

![](./fig/23_manual-tracking-3D.jpg)

![](./fig/25_chaingraph-tracking-3d.jpg)



# References

<a name="ref_chaingraph">&nbsp;</a>
\[1\] B. X. Kausler, M. Schiegg, B. Andres, M. Lindner, H. Leitte, L. Hufnagel, U. Koethe, F. A. Hamprecht. 
**A Discrete Chain Graph Model for 3d+t Cell Tracking with High Misdetection Robustness.**
*Proceedings of the European Conference on Computer Vision (ECCV 2012)*, Florence, Italy, October, 2012.
