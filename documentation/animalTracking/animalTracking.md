---
layout: documentation
title: Animal Tracking
tagline: Animal Tracking
category: "Documentation"
group: "workflow-documentation"
weight: 2
---
# Animal Tracking Tutorial

## Overview

The `Animal Tracking Workflow` allows users to "track" lab animals, also called objects, in their 2D+t or 3D+t videos. 
With minimal effort, the users have to provide sparse labels and define a few parameters, and Ilastik will automatically assign IDs to each object on the video. 
These labels and parameters will also be stored in a `.ilp` project file, which can later be re-used to setup a tracking pipeline in order to process multiple videos.  

This tracking workflow can account for appearances or disappearances, over-segmentation and mergers (clusters of objects), and has already been used successfully to track flies, mice, larvae, and zebrafish. 
Some examples of the results can be observed in the following videos:

The following tutorial shows a step-by-step guide to setup a tracking pipeline for your experiments. 
To follow the tutorial, you can download the sample files `flyBowlMovie200.h5`  `flyBowlMovie200.h5` and `flyBowlMovie200.h5_Simple Segmentation.h5` 

Some of the topics that will be covered include the following:

* Background and foreground pixel segmentation (classification)
* Animal tracking with merger resolution
* Exporting results in different formats
* Setting up a tracking pipeline



## Pixel Foreground/Background Segmentation (Using the [Pixel Classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html) Workflow)

On the `startup screen` create a new pixel classification project by selecting `Pixel Classification` and choosing a destination and a name for your `.ilp` project file. 
This file will store all the project parameters, including the labels and a trained foreground/background classfiier, and can be used later to setup a segmentation and tracking pipeline. 

<a href="./fig/startupSegmentation.png" data-toggle="lightbox"><img src="./fig/startupSegmentation.png" class="img-responsive" /></a>

Once you're create the `.ilp` pixel classification project, you will see multiple options on a bar on the left side of the GUI.
Locate and click on the `Add New...` button located on the `Raw Image` section, and load your file.
For this tutorial, the file `movie200.h5` will be loaded.

<a href="./fig/addNewSegmentation.png" data-toggle="lightbox"><img src="./fig/addNewSegmentation.png" class="img-responsive" /></a>

<span style="color:blue">**Note:** *You can load videos in multiple formats that include `.ufmf`, `.mmf`, and `.h5`. You will also be able to load avi and mpg videos in the next release.*</span>

After you select your file, your GUI should display the video (shown in the screenshot below). 
You can use the time slider, highlighted in red, to navigate the frames of your video. 
You can also use `Shift` + `Mouse-Wheel` to scroll through frames, and `Ctrl` + `Mouse-Wheel` to zoom in/out. 

<a href="./fig/loadVideoSegmentation.png" data-toggle="lightbox"><img src="./fig/loadVideoSegmentation.png" class="img-responsive" /></a>

Now that you loaded your data, click on `Feature Selection>Select Features...` to display the feature dialog. 
This dialog lists color, edge and, texture features that can be used to train the foreground/background classifier.
Select all of the features (as shown on the screesnhot below) to get the best quality possible, but keep in mind that the more features you select, the longer it will take to run.

<a href="./fig/featuresSegmentation.png" data-toggle="lightbox"><img src="./fig/featuresSegmentation.png" class="img-responsive" /></a>

Click on `Training` on the left bar, and then click on `Add Label` 2 times, in order to add 2 labels for the background and the foreground. 
After you add both labels, click on the `Brush` button ![Brush Button](./fig/brushSegmentation.png), and paint a few foreground and background labels (usually red or channel 0 for background and green or channel 1 for foreground).
You can click on the `Live Update` button to get live feedback on your results as you draw labels. 
It's also recommended to draw a few labels on multiple frames, and maybe even multiple videos to make the classifier more robust for videos with varying lighting conditions for example. 

<a href="./fig/trainingSegmentation.png" data-toggle="lightbox"><img src="./fig/trainingSegmentation.png" class="img-responsive" /></a>

Now that you trained the foreground/background classifier, click on `Prediction Export`, and then click on the `Export All` button to export the background/foreground segmentation probabilities (per pixel).

<a href="./fig/exportSegmentation.png" data-toggle="lightbox"><img src="./fig/exportSegmentation.png" class="img-responsive" /></a>

Finally, make sure to save your project on `Project>Save project` in the top menu, since you will be using this project later to process other videos.

More detailed instructions on the pixel classification workflow can be found [here]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html).



### 2. Automatic Tracking (Using the Animal Tracking Workflow) 

## Exporting the Results

Users can also export the tracking results in different formats that include a `.csv` table with assigned IDs and object properties, a `.outline` file with object contours, or `.h5` HDF5 volumes with the ID information.

* `CSV table:` A table with a row for each object in the video, and corresponding properties that include the time (frame number), track ID, center, area, major/minor axes, bounding box, etc. 
* `Object Contours:` Larvae contours
* `Multi-Worm-Tracker:` Export `.blobs` and `.summary` files in the MWT format

## Setting Up a Tracking Pipeline (Batch Processing)

There are 2 ways to process multiple videos on the tracking workflow: Using the `Batch Processing` applet on the GUI, or processing multiple videos with ilastik's `headless` mode from the command line.

To run it on the cluster I create a .sh file:

~~~
>>>vi <your-bash-file>.sh
~~~

With the following 2 lines (one for segmentation and one for tracking):

~~~
./run_ilastik.sh --headless --project=<your-pixel-classification-project>.ilp --raw_data=<your-movie>.ufmf --export_source='Simple Segmentation' --pipeline_result_drange="(1,2)" --export_drange="(0,1)" --export_dtype=uint8

./run_ilastik.sh --headless --project=<your-tracking-file>.ilp --raw_data=<your-movie>.ufmf --segmentation_image=<your-movie>_Simple Segmentation.h5" --export_source="tracking-result" --export_source="Plugin" --export_plugin="CSV-Table"
~~~

It's important to mention that there are two new arguments used to export the CSV table: --export_source="Plugin" --export_plugin="CSV-Table"
Also, notice that the segmentation file will always have the name "<your-movie>_Simple Segmentation.h5" so you can just copy and paste these two lines for each movie or use a bash for-loop with your movie as the input argument.

After I create the bash script, I turn the .sh script into an executable, and I run it on the cluster with these 2 commands (using 32 cores):

~~~
>>>chmod u+x <your-bash-file>.sh
>>>qsub -pe batch 32 -b y -cwd ./<your-bash-file>.sh
~~~

## How does it work?