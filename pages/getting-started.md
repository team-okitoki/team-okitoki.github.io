---
layout              : page
show_meta           : false
title               : "Getting Started in 10 Steps  "
subheadline         : "A Step-by-Step Guide"
teaser              : "This step-by-step guide helps you to customize Feeling Responsive to your needs."
permalink           : "/getting-started/"
---
<ul>
    {% for post in site.categories.getting-started %}
    <li><a href="{{ site.url }}{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
</ul>