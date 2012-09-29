---
layout: page
title: Hire me
my_github: https://github.com/gordonslondon
socials:
  - type: twitter
    username: gordonslondon
    url: "http://twitter.com/gordonslondon"
  - type: github
    username: gordonslondon
    url: "http://github.com/gordonslondon"
  - type: linkedin
    username: julesboussekeyt
    url: "http://www.linkedin.com/in/julesboussekeyt"
---

## Hello

My name is __Jules Boussekeyt__ and I am a __PHP__ and __Javascript__ developer.
I'm specialized in __Symfony2__ and __Backbone.js__. I enjoy __large scale architecture__,
__innovative projects__, write __clean/simple code__ and __test driven development__.


## Previously

I'm a programmer since 5 years, I've started with a e-commerce. Recently I've work in big 
companies (SensioLabs) but also smallest startups (Twitspark, Balloon). I've also done some 
side projects. I'm now working mainly with Javascript using Backbone.js, Require.js, Mocha, Node.js; although 
I still enjoy doing some PHP occasionally.


## Freelance

I'm available for web development consulting and freelance. I'm used to work in teams or alone,
on new or existing projects. I can help you with early stage of your project like design the UI,
I can also improve your existing software, or help you with difficult tasks.


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
