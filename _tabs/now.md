---
title: Now
permalink: /now/
order: 3
icon: fa-solid fa-clock
---
I like to periodically post an update rounding up what I've been up to. This page shows the most recent entry. Hopefully it's not too old!

{% assign now_posts = site.categories.Now %}
{% if now_posts %}
  {% assign sorted_now_posts = now_posts | sort: "date" | reverse %}
  {% assign latest_post = sorted_now_posts[0] %}

  <article class="post">
    <h1><a href="{{ latest_post.url }}">{{ latest_post.title }}</a></h1>
    <p><small>{{ latest_post.date | date: "%B %d, %Y" }}</small></p>
    <div class="content">
      {{ latest_post.content }}
    </div>
  </article>
{% else %}
  <p>No posts in the "Now" category found.</p>
{% endif %}