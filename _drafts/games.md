---
order: 6
icon: fas fa-gamepad
toc: true
title: "My Games"
---

{% for game in site.my-games reversed %}
  <h2>{{ game.title }}</h2>
  <i>{{ game.date }}</i>
  <p>{{ game.content | markdownify }}</p>
  <hr>
{% endfor %}
