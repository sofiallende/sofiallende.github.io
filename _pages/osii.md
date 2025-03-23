---
permalink: /osii/
title: "OSII"
author_profile: true
---

The Arctic region has undergone profound transformations in recent decades due to a rapid decline in sea ice extent. These shifts impact the interplay between sea ice, the atmosphere, and the ocean, involving complex thermodynamic and dynamic processes. Understanding these interactions is crucial for addressing the repercussions of Arctic climate change. However, existing models used for climate projections struggle to capture fine-scale processes at the ocean-sea ice boundary, necessitating parametrizations. Unfortunately, these parametrizations are grounded in empirical rather than theoretical foundations, limiting their applicability across diverse ocean conditions.

<img src="/images/logo_marie-curie.jpg" align='right' width="250" />

Recent studies highlight the increased role of wind-driven mixing at the ocean-sea ice interface and the lack of studies that include the joint effect of double diffusion convection, two fundamental processes occurring in sea ice-covered regions. The OSII project seeks to bridge this critical gap by employing highly efficient direct numerical simulations (DNS). This innovative approach promises a more precise comprehension of ice melting rates and boundary-layer dynamics resulting from the complex interplay of internal waves/tides and double diffusion convection.

The OSII project is committed to:

- Quantifying the influence of tides on double diffusion convection within a homogeneous fluid flow.
- Exploring the interplay between internal waves induced by a wave-maker and double diffusion convection in stratified flows.

- Enhancing the vertical mixing parametrization within the NEMO-SI3 general circulation model through insights derived from DNS outcomes.


{% for collection in site.collections %}
{% if collection.label == "osii" %}
  {% for post in collection.docs reversed %}
      {% include archive-single.html %}
  {% endfor %}
{% endif %}
{% endfor %}
