---
order: 6
icon: fas fa-gamepad
toc: true
title: "My Games"
# media_subpath: ./../assets/my-games
---

{% for game in site.my-games reversed %}
  <h2>{{ game.title }}</h2>
  <i>{{ game.date }}</i>
  <p><img src="{{ game.featured-image }}" alt="{{ game.description }}"></p>
  <p>{{ game.content | markdownify }}</p>
  <hr>
{% endfor %}
