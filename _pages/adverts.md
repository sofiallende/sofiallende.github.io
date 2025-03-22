---
permalink: /adverts/
title: "Adverts!"
author_profile: true
---

{% assign now = 'now' | date: '%s' %}

{% for collection in site.collections %}
{% if collection.label == "notes" %}
  {% for post in collection.docs reversed %}
    {% assign event_time = post.expiry | date: '%s' %}
      {% if now < event_time %}
         {% include archive-single.html %}
      {% endif %}
  {% endfor %}
{% endif %}
{% endfor %}

## Past

{% for collection in site.collections %}
{% if collection.label == "notes" %}
  {% for post in collection.docs reversed %}
    {% assign event_time = post.expiry | date: '%s' %}
      {% if now > event_time %}
         {% include archive-single.html %}
      {% endif %}
  {% endfor %}
{% endif %}
{% endfor %}
