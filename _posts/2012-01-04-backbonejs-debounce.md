---
layout: post
tags: frontend
title: How to delay a method in BackboneJS
---

I've been trying to __delay an expensive search triggered by a `keyup` event__ with BackboneJS.

### The problem

I have a BackboneJS View, where each key pressed triggers `fetchApi` method:

{% highlight javascript %}
window.MyView = Backbone.View.extend({
    // ...
    events: {
        'keyup input': 'fetchApi'
    },

    fetchApi: function() {
        // expensive method with api calls
    }
   // ...
});
{% endhighlight %}

Unfortunately each time a key is pressed a call to the API is done. A better solution would be to wait that the user has finished typing.

### The solution

With `debounce` method in [underscore.js](http://documentcloud.github.com/underscore/#debounce)  it's pretty easy to delay the `fetchApi` method, like this:


{% highlight javascript %}
window.MyView = Backbone.View.extend({
    // ...
    events: {
        'keyup input': 'fetchApi'
    },

    fetchApi: _.debounce(function() {
        // expensive method with api calls
    }, 800)
   // ...
});
{% endhighlight %}

You're done!
Each time a key is pressed, the script wait 800ms, then call `fetchApi`. 
If a key is pressed durings these 800ms, the script wait 800ms again.

