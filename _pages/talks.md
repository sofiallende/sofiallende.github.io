---
permalink: /talks/
title: "Selected talks"
author_profile: true
---

{% for collection in site.collections %}
{% if collection.label == "talks" %}
  {% for post in collection.docs reversed %}
      {% include archive-single-talk.html %}
  {% endfor %}
{% endif %}
{% endfor %}


