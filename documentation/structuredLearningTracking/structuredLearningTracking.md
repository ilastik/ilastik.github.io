<!-- ---
title: Tracking with Learning
tagline: Structured Learning Tracking
category: "Documentation"
group: "workflow-documentation"
weight: 2
---
# Structured Learning Tracking with Tracking Training


## 3. Tracking:
The remainder of this tutorial first discusses the training for tracking, 
and then reviews the structured learning tracking applet of the [**structured learning tracking workflow**](#sec_structured_learning_tracking).

Structured learning tracking workflow can process 2D+time (`txy`) as well as 3D+time (`txyz`) datasets. This
tutorial guides through a 2D+time example, and a 3D+time example dataset is provided and discussed
[at the end of the tutorial](#sec_3d_slt).


## 4. Structured Learning:
Automatic tracking uses a set of weights associated with detections, transitions, divisions, appearances, and disappearances to balance the components of the energy function optimized.
Default weights can be used or they can be user specified. In structured learning we use the training annotations and all the classifiers to calculate optimal weights 
for the given data and training - press the "Calculate Weights" button.
To obtain a tracking solution press "Track!" button.
The user can also input weights obtained from other similar data sets and by pass the learning procedure.   

The following two diagrams show the difference of automatic tracking using the default weights and weights obtained by structured learning.
Example areas of change are circled in red.

<a href="./fig/slt_compare_automatic_circled.png" data-toggle="lightbox"><img src="./fig/slt_compare_automatic_circled.png" class="img-responsive" /></a>

<a href="./fig/slt_compare_slt_circled.png" data-toggle="lightbox"><img src="./fig/slt_compare_slt_circled.png" class="img-responsive" /></a>

 
To export the tracking result for further analysis, the user can choose between different options described next.


## References

<a name="ref_conservation"> </a>
\[1\] M. Schiegg, P. Hanslovsky, B. X. Kausler, L. Hufnagel, F. A. Hamprecht. 
**Conservation Tracking.**
*Proceedings of the IEEE International Conference on Computer Vision (ICCV 2013)*, 2013.
 -->