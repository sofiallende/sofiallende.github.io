---
permalink: /teaching/
title: "Teaching"
author_profile: true
---
{% for collection in site.collections %}
{% if collection.label == "courses" %}
  {% for post in collection.docs reversed %}
      {% include archive-single-course.html %}
  {% endfor %}
{% endif %}
{% endfor %}


