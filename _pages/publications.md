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


# Comming soon

- Characterizing Mixing-Length Growth and  Melt Rates at the Ice-Ocean Interface
- Summer and winter deppening of the mixed layer in pan-Arctic Seas


