---
layout: post
tags: frontend
title: Memory free Backbone Router
---

Backbone.js lets you build your javascript application the way you want, 
but as many have noticed there's often __some weird problems when developping Backbone.js
applications__. Sometimes it's a click event that is triggered mutliple
times, or not trigger at all. It can also be a change inside a model occurring multiple times repeatedly updating the view.

In this post we're going to dig in a concrete example of a misconcepted backbone application and see how to
improve it. Let's start directly with an example: we have a router rendering some views:

<hr/>

__Question__: There's a problem in the following example; do you see it?

{% highlight javascript %}
var Views = []

var Router = Backbone.Router.extend({
    routes: {
        'load/:index': 'loadView'
    },

    loadView: function(index) {
        var model = new Backbone.Model({
            index: Number(index),
            name: 'view' + index
        })
        var view = new View({
            model: model
        })

        // register the view to manipulate it after
        Views.push(view)

        // render the view
        $('#app').html(view.render().$el)
    }
})

var View = Backbone.View.extend({
    tagName: 'div',
    
    initialize: function() {
        this.model.on('change:name', function(model, name) {
            console.log('name is now: ' + name)
        })
    },
            
    render: function() {
        this.$el.html(
            '<h1>'+this.model.get('name')+'</h1>' +
            '<a href="#load/'+this.model.get('index')+1+'">next</a>'
        )
        return this
    }
})    
{% endhighlight %}

<hr/>
    
__Problem__: We've create a "ghost view"; `loadView()` instanciates a new view but it doesn't destroy the previous view.

With further illustration of the previous code, the following example illustrates the __"ghost view"__ effect:

{% highlight javascript %}
var router = new Router()
Backbone.history.start()

// Load first view
window.location.hash = '#load/0'

// update model of the first view
Views[0].model.set('name', 'John') 
// => name is now: John
    
setTimeout(function() {
    // Load a second view
    window.location.hash = '#load/1'

    // This is the problem, updating the model of the first view still
    // triggers a "change" event although the view isn't present in the DOM anymore
    Views[0].model.set('name', 'Balthazar')
    // => name is now: Balthazar
}, 2000)
{% endhighlight %}

You can see it happen in [this jsfiddle](http://jsfiddle.net/NprJr/) (keep your console open)

<hr/>

__Solution__: Call "remove()" on previous view

So know, how can we fix it? It's pretty straight forward. Our previous router code was something like:

{% highlight javascript %}

    // ...

    loadView: function(index) {
        var model = new Backbone.Model({
            index: Number(index),
            name: 'view' + index
        })
        var view = new View({
            model: model
        })

        // register the view to manipulate it after
        Views.push(view)

        // render the view
        $('#app').html(view.render().$el)
    }
{% endhighlight javascript %}


All that we have to do now is call the `remove()` method on the preview view:

{% highlight javascript %}

    // ...

    loadView: function(index) {
        var model = new Backbone.Model({
            index: Number(index),
            name: 'view' + index
        })
        var view = new View({
            model: model
        })

        // register the view to manipulate it afterwards
        Views.push(view)

        // unbind all events of the previous view to avoid "ghost views"
        if (this.previousView) this.previousView.remove()

        // save reference of the view
        this.previousView = view

        // render the view
        $('#app').html(view.render().$el)
    }
{% endhighlight javascript %}


Calling `remove()` on a Backbone.View does several things:

- Remove Javascript events (click, keypress, blur, ...)
- Unbind all events of the model (change, sync, remove)
- Remove the element from the DOM


With this trick you can be sure your backbone.js application will perform well, become easier to debug and it will save you plenty of headaches in the future.

Stay tuned for some other [Backbonejs tips and tricks](http://jules.boussekeyt.org/2012/backbonejs-tips-tricks.html)
