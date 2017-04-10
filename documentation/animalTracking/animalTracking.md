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

The following tutorial shows a step-by-step guide to setup a tracking pipeline for your experiments. Some of the topics that will be covered include the following:

* Background and foreground pixel segmentation (classification)
* Animal tracking with merger resolution
* Exporting results in different formats
* Setting up a tracking pipeline

## Background/Foreground Segmentation and Automatic Tracking

The tracking process requires two important steps: high quality foreground/background segmentation, and global optimization across frames. 

### 1. Pixel Foreground/Background Segmentation (Using the [Pixel Classification]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html) Workflow)

### 2. Automatic Tracking (Using the Animal Tracking Workflow) 

## Exporting the Results

Users can also export the tracking results in different formats that include a `.csv` table with assigned IDs and object properties, a `.outline` file with object contours, or `.h5` HDF5 volumes with the ID information.

* `CSV table:` A table with a row for each object in the video, and corresponding properties that include the time (frame number), track ID, center, area, major/minor axes, bounding box, etc. 
* `Object Contours:` Larvae contours
* `Multi-Worm-Tracker:` Export `.blobs` and `.summary` files in the MWT format

## Setting Up a Tracking Pipeline (Batch Processing)

There are 2 ways to process multiple videos on the tracking workflow: Using the `Batch Processing` applet on the GUI, or processing multiple videos with ilastik's `headless` mode from the command line.

## How does it work?