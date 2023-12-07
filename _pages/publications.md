---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---
{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}

---
title: "Coming soon"
---

Allende, S. 2023. “Impact of ocean vertical mixing parametrization on sea ice properties using NEMO-SI3 model”. Target Journal: Geoscientific Model Development


Bec, J. and Allende, S. 2023. “Small-scale alignment and clusters of heavy inertial spheroids in turbulent flow”. Target Journal: Physical review letters
