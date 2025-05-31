---
order: 6
icon: fas fa-book
toc: true
title: "The Door in the Dressing Gown"
---
I've been writing a piece of fiction for, and sort of with, my son Ari for a few months now. Some evenings at bedtime I'll come up with a short chapter. I have no overriding structure or big goal, but I'm feeling my way towards a few ideas I hope he finds fun.

As I think of it and have time, I'll add the posts to the blog, backdated when necessary. [Jekyll, the CMS tech I'm using](https://jekyllrb.com/) allows me to make pages like the below where all the posts are collated in order. I hope you enjoy it! Any feedback, please [reach out](mailto:ben@ben.ie) and let me know.

<h1>{{ page.title }}: Collected Writing</h1>

{%- assign selected_posts = site.posts | where_exp: "post", "post.tags contains 'Door in the Dressing Gown'" -%}

{%- assign sorted_posts = selected_posts | sort: "sort_order" -%}

{%- for post in sorted_posts -%}
  <article>
    <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
    <p><small>{{ post.date | date: "%B %d, %Y" }}</small></p>
    <div>
      {{ post.content }}
    </div>
    <hr>
  </article>
{%- endfor -%}