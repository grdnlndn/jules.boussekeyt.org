---
layout: post
tags: frontend
title: Utility functions for Backbone.js
---


Backbone.js is a thing of beauty; it contains everything needed to create an application. Let's take a 
look here at some utility functions we can reuse for every project.


## Create an alias for templating engine

A good thing to do when starting a new backbone application is to create an alias for the template engine. 
For example, our views are no longer tied to a specific template engine, and we can replace it more easily later 
if necessary:

```javascript

Backbone.View.prototype.template = function(tmpl, params) {
    // use handlebars
    return tmpl(param)

    // use underscore
    return _.template(tmpl, params)
}

Backbone.View.extend({

    render: function() {
        // will call our template engine without know which one it is
        this.template(tmplStr, {})
    }

})
```

## Ease debugging of Backbone events


It's common to debug all events coming from a model/view/collection. An easy way to accomplish this
is to enable debugging of all events:


```javascript
Backbone.Collection.prototype.debugEvents =
Backbone.Model.prototype.debugEvents =
Backbone.View.prototype.debugEvents =
Backbone.Router.prototype.debugEvents = function() {
    this.on('all', function(eventName) {
        console.log('[debug event] --> ', eventName, Array.prototype.slice.call(arguments, 1))
    })
}

// example
var model = new Backbone.Model()
model.debugEvents()

model.trigger('change', 'foo', 'bar') // [debug event] change ['foo', 'bar']
```

## Ease calling super() when overriding a method


It's a common practice to override `view.remove()` method to add custom logic. When doing that we should
never forget to call parent's `remove()` method:


```javascript
Backbone.View.extend({

    remove: function() {
        // ... custom logic

        // call parent remove()
        this.constructor.__super__.remove.apply(this, arguments)
    }

})
```

Calling parent's `remove()` method is ugly and difficult to remember; the idea is to create a 'shortcut' called `_super()`:

```javascript
Backbone.View.extend({

    remove: function() {
        // ... custom logic

        // call parent remove()
        this._super('remove', arguments)
    }

})


Backbone.Model.prototype._super =
Backbone.View.prototype._super =
Backbone.Router.prototype._super =
Backbone.Collection.prototype._super = function(funcName){
  return this.constructor.__super__[funcName].apply(this, _.rest(arguments));
}
```


### Identify 'console.log' in a view 

Think of a list of items in which each item is represented by a single view. Our view is called `ItemView` and 
we instanciate it with the number of items we have. Now if we do a `console.log` inside one of those views, we can't 
figure out which one the log came from. Adding view's `cid` to our logs might prove to be the solution:

```javascript
Backbone.Model.prototype.log =
Backbone.View.prototype.log = function() {
    console.log.apply(console, ['[' + this.cid + ']'].concat([].splice.call(arguments, 0)))
}

var ItemView = Backbone.View.extend({
    method: function() {
        this.log('method() called')
    }
})

var items = [new ItemView(), new ItemView(), new ItemView()]
items[_.random(0, 2)].method() // [view(?)] method() called
```


## Dispatching events among all views

If we need to communicate among all views of a project, we should create a global event listener. Events 
will be dispatched among all views:

```javascript
Backbone.View.prototype.eventAggregator = _.extend({}, Backbone.Events);


var view1 = new Backbone.View()
var view2 = new Backbone.View()

view1.on('disconnect', function() {
    console.log('view1 disconnected')
})

view2.trigger('disconnect') // 'view1 disconnected'
```


## Prevent using non-existing selectors in views

When finding elements inside a view using `this.$('.element')`, we expect to find at least one element. Unfortunately,
if `.element` returns an empty element and we're calling some jQuery methods on it, it will have no effect at all. By 
throwing an error in that case, our application becomes more robust:

```javascript
var view$ = Backbone.View.prototype.$
Backbone.View.prototype.$ = function(selector) {
    var element = view$.apply(this, arguments)

    if (!element.length === 0) {
        console.error("[Backbone.View] Warning: selector '" + selector + "' do not match any element")
    }

    return element
}

Backbone.View.extend({

    initialize: function() {
        // obviously .foo element do not yet exists because view is not rendered
        this.$('.foo') // [Backbone.View] Warning: selector '.foo' do not match any element
            .text('foo-bar-baz') 
    }

})

```

But sometimes we want to find an element even if it doesn't exist and it's a valid use case. A 
workaround to avoid the error is to use `this.$el.find('.selector')` instead of `this.$('.selector')`.


### Search in models and collections


To know if one of a model's attributes match a pattern, we can create a new method called 'model.match(/exp/)':


```javascript
Backbone.Model.prototype.match = function(test) {
    return _.any(this.attributes, function(attr) {
        return _.isRegExp(test) ? test.test(attr) : attr == test
    })
}

var model1 = new Backbone.Model({ first_name: 'Jordan', last_name: 'Aslam' })
var model2 = new Backbone.Model({ first_name: 'John', last_name: 'Doe' })

console.log(model1.match('Jordan')) // true
console.log(model2.match('Doe')) // true

console.log(model1.match(/Jo/)) // true
console.log(model2.match(/Jo/)) // true
```

We can do the same for collections with 'coll.search(/exp/)' to allow filtering of models:


```javascript
Backbone.Collection.prototype.search = function(test) {
    return this.filter(function(model) {
        return model.match(test)
    })
}


var coll = new Backbone.Collection([model1, model2])

console.log(coll.search('Jordan').first().get('last_name')) // Aslam
console.log(coll.search('John').first().get('last_name')) // Doe

console.log(coll.search(/Jo/).pluck('last_name')) // ['Aslam', 'Doe']
console.log(coll.search(/Jordan|John/).pluck('last_name')) // ['Aslam', 'Doe']
```

## before() and after() methods when an action is called


Sometimes we have a complex router and need to have 'pre' and 'post' logic each time an action is called. Let's add 
`before()` and `after()` callbacks to match our needs:


```javascript
var $route = Backbone.Router.prototype.route
Backbone.Router.prototype.before = function() {}
Backbone.Router.prototype.after = function() {}
Backbone.Router.prototype.route = function(route, name, callback) {

    if (_.isFunction(name)) {
        callback = name
        name = ''
    }

    if (!callback) callback = this[name]

    var wrapped = _.bind(function() {
        this.before.apply(this, arguments)
        callback.apply(this, arguments)
        this.after.apply(this, arguments)
    }, this)

    return $route.call(this, route, name, wrapped)
}

var Router = Backbone.Router.extend({
    before: function() { console.log('before') },
    after:  function() { console.log('after') },

    routes: {
        '': function() { console.log('index') }
    }
})

var router = new Router()
Backbone.history.start()

router.navigate('') // 'before' 'index' 'after'
```



