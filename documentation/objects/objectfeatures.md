---
title: Object Classification Feature Table
tagline: Object Classification Feature Table
category: "Documentation"
group: "workflow-documentation-details"
weight: 1
---

# Object Classification Feature Table


{% for plugin in site.data.objectfeatures.features %}

## {{ plugin[0] }}
{% for feature in plugin[1] -%}
{% unless feature.advanced or (feature.advanced == nil) -%}
{% assign anchor = feature.displaytext | downcase | replace: " ", "-" -%}
<div class="feature-card">
    <div class="feature-header" id="{{ anchor }}">{{ feature.displaytext }}</div>
    <div class="feature-description">{{ feature.detailtext }}</div>
</div>

{% endunless %}
{% endfor %}
{% endfor %}
