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
    url: "http://www.linkedin.com/in/julesboussekeyt"
  - type: skype
    username: grdnlndn
    url: "http://skype.com"
---

## Hello

I specialize in __Symfony2__ and __Backbone.js__. I enjoy __large scale architecture__,
__innovative projects__, writing __clean/simple code__ and __test driven development__.


## Previously

I've been a programmer for 5 years, getting my start in a e-commerce. Recently I've work in both big 
companies ([SensioLabs](http://sensiolabs.com)) and the smallest of startups ([Twitspark](http://www.twitspark.com), [Everlution](http://everlution.com), [Wisembly](http://votrequestion.com)). I've also done some 
side projects. I now working mainly with Javascript using Backbone.js, Require.js, Mocha, Node.js; although 
I still enjoy doing some PHP occasionally.


## Freelance

I'm available for web development consulting and freelance. I'm confortable working in teams or alone,
on new or existing projects. I can help you with the early stage of your project like designing the UI, 
improve your existing software, or help you with difficult tasks.


## Personal projects

I've created a canvas game, [moto-game.org](http://moto-game.org).


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
