---
layout: page
title: Hire me
my_github: https://github.com/grdnlndn
socials:
  - type: twitter
    username: grdnlndn
    url: "http://twitter.com/grdnlndn"
  - type: github
    username: grdnlndn
    url: "http://github.com/grdnlndn"
  - type: linkedin
    username: julesboussekeyt
    url: "http://www.linkedin.com/profile/view?id=143222797"
  - type: skype
    username: grdnlndn
    url: "http://skype.com"
---

## Hello

I'm a PHP and Javascript developer. I enjoy building web-applications.

## Previously

I've been doing web programming since 2008, getting my start in a e-commerce. Recently I worked for 
agencies ([SensioLabs](http://sensiolabs.com), [Everlution](http://everlution.com)) and startups ([Twitspark](http://www.twitspark.com), [Wisembly](http://votrequestion.com)). I've also done some 
side projects. I'm now working mainly with Javascript using Backbone.js, Require.js, Node.js; although 
I still enjoy doing some PHP.


## Freelance

I'm available for web development consulting and freelance. I'm confortable working in teams or alone,
on new or existing projects. I can help you with the early stage of your project like designing the UI, 
improve your existing software, or help you with difficult tasks.


## Skills

<ul class="tag-list">
    <li><a>Symfony2</a></li>
    <li><a>Doctrine2</a></li>
    <li><a>REST Api</a></li>
    <li><a>Backbone.js</a></li>
    <li><a>jQuery</a></li>
    <li><a>Socket.io</a></li>
    <li><a>Git</a></li>
    <li><a>Vim</a></li>
    <li><a>Debian</a></li>
    <li><a>Mongodb</a></li>
    <li><a>Mysql</a></li>
    <li><a>CSS3</a></li>
    <li><a>HTML5</a></li>
    <li><a>Node.js</a></li>
</ul>

## Personal projects

- [I created a Conway's Game of Life using a `<canvas>` element](http://grdnlndn.github.io/game-of-life/)


## Find me on the web

<div class="icons">
{% for link in page.socials %}
<div class="icon">
    <a href="{{ link.url }}" target="_blank">
        <img src="/assets/images/{{ link.type }}-icon.png" alt="{{ link.type }} {{ link.username }}">
        <span>@{{ link.username }}</span>
    </a>
</div>
{% endfor %}
</div>

## Contact

My mail is <a id="eliam"></a>, drop me a line, I'm looking forward to work with you!



<script>
  var el = document.getElementById('eliam')
  var m = ['jules', 'boussekeyt'].join('.') + '@' + ['gmail', 'com'].join('.')

  el.innerHTML = m
  el.href = 'otliam'.split('').reverse().join('') + ':' + m
</script>
