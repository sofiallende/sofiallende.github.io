---
layout: archive
title: "Thesis"
permalink: /thesis/
author_profile: true
---

This thesis analyses the dynamics of small complex objects, such as fibres or spheroids, that interact with a turbulent random environment. The aim is to gain physical understanding on how turbulent fluctuations affect the dynamics of non-spherical particles, inducing phenomena such as preferential concentration, deformation or catastrophic events as their fragmentation. Such developments pave the way for the design of stochastic parameterisations of violent events in industrial codes.

{% include base_path %}

{% for post in site.thesis reversed %}
  {% include archive-single.html %}
{% endfor %}
