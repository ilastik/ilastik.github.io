---
title: Object Classification Features
tagline: Object Classification Features
category: "Documentation"
group: "workflow-documentation-details"
weight: 1
---

# Object Classification Features

ilastik object features describe objects in terms of numbers.
These are used in classification to differentiate between different types of objects (classes).
Per default ilastik comes with 3 feature plugins: "Standard Object Features", "Skeleton Features" (2D only), and "Convex Hull Features".

A short overview of available object features is given in the following segment of the webinar [ilastik beyond pixel classification - [NEUBIASAcademy@Home]](https://youtu.be/_ValtSLeAr0):

{% include lazy_yt.html video_id="\_ValtSLeAr0" params="start=840&end=1367" %}

Some practical advice on selecting features can be found in our i2k ilastik tutorial:

{% include lazy_yt.html video_id="F6KbJ487iiU" params="start=3519&end=3700" %}

Following here is a list of all available object features along with their description.

## Standard Object Features

{% for feature in site.data.objectfeatures.features["Standard Object Features"] -%}
{% unless feature.advanced or (feature.advanced == nil) -%}
{% assign anchor = feature.displaytext | downcase | replace: " ", "-" -%}
<div class="feature-card">
    <div class="feature-header" id="{{ anchor }}">{{ feature.displaytext }}</div>
    <div class="feature-description">{{ feature.detailtext }}</div>
</div>

{% endunless %}
{% endfor %}

## Convex Hull Features

{% for feature in site.data.objectfeatures.features["2D Convex Hull Features"] -%}
{% unless feature.advanced or (feature.advanced == nil) -%}
{% assign anchor = feature.displaytext | downcase | replace: " ", "-" -%}
<div class="feature-card">
    <div class="feature-header" id="{{ anchor }}">{{ feature.displaytext }}</div>
    <div class="feature-description">{{ feature.detailtext }}</div>
</div>

{% endunless %}
{% endfor %}

## Skeleton Features

{% for feature in site.data.objectfeatures.features["2D Skeleton Features"] -%}
{% unless feature.advanced or (feature.advanced == nil) -%}
{% assign anchor = feature.displaytext | downcase | replace: " ", "-" -%}
<div class="feature-card">
    <div class="feature-header" id="{{ anchor }}">{{ feature.displaytext }}</div>
    <div class="feature-description">{{ feature.detailtext }}</div>
</div>

{% endunless %}
{% endfor %}


## Spherical Texture Features

Extracts Spherical Textures: Angular mean projections of 2D or 3D image objects, as described in [this preprint](https://www.biorxiv.org/content/10.1101/2024.07.25.605050v1.full).
Spherical Texture features were first incorporated into ilastik in version `1.4.1b19`.

{% for feature in site.data.objectfeatures.features["Spherical Texture"] -%}
{% unless feature.advanced or (feature.advanced == nil) -%}
{% assign anchor = feature.displaytext | downcase | replace: " ", "-" -%}
<div class="feature-card">
    <div class="feature-header" id="{{ anchor }}">{{ feature.displaytext }}</div>
    <div class="feature-description">{{ feature.detailtext }}</div>
</div>

{% endunless %}
{% endfor %}
