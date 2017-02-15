---
layout: documentation
title: Autocontext
tagline: Multi-stage pixel classification
category: "Documentation"
group: "workflow-documentation"
weight: 0
---
# Autocontext -- cascaded pixel classification

## What is it and when do you need it
This workflow improves pixel classification by running it in multiple stages and showing each pixel the results of the previous stage. The core algorithm has been introduced by [Tu and Bai](https://www.ncbi.nlm.nih.gov/pubmed/20724753). Briefly, the first stage of autocontext is simply pixel classification. The output of this stage is added as new channels to the raw data and then used as input to the second stage. If more than two stages are used the procedure is repeated. We have additionally modified the algorithm to not only use the results of the previous stage at prediction, but to also compute features on these results. 

We find this workflow to be particularly efficient in cases where the image data shows multiple distinct classes. In the following we will illustrate the use of this workflow by the problem of membrane detection in EM data. In the first stage we define 5 classes: membrane, cytoplasm, synapse, vesicles, mitochondria, mitochondrial membrane. In the second stage we only define 2 classes: membranes and the rest. As shown in the figure below, the second stage can profit from more context and its predictions are much cleaner than those of the first stage. 


