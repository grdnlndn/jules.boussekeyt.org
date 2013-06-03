---
layout: post
tags: frontend
title: CSS3 Mobile Application Layout using Less
---



Main purpose of this post is to create a CSS3 animation to slide pages horizontaly. Below a 
mobile app with 3 pages on 3 different levels (a level is like a sub-menu). Animation is created 
by switching `current` class alternatively on each level:

<div class="iphone">
    <div class="crop">
        <div class="level level-0 current">&nbsp;</div>
        <div class="level level-1">&nbsp;</div>
        <div class="level level-2">&nbsp;</div>
    </div>
    <script>
        var l = 1
        setInterval(function() {
            document.querySelector('.iphone .level-0').classList[l === 0 ? 'add' : 'remove']('current')
            document.querySelector('.iphone .level-1').classList[(l === 1 || l === 3) ? 'add' : 'remove']('current')
            document.querySelector('.iphone .level-2').classList[l === 2 ? 'add' : 'remove']('current')
            l++
            if (l == 4) l = 0
        }, 2400)
    </script>
</div>


<div class="post-buttons">
    <a class="demo-btn" href="/assets/examples/mobile-layout.html" target="_blank">Demo</a>
    <a class="source-btn" href="/assets/examples/mobile-layout.html" target="_blank">Source</a>
</div>

## Create a sliding effect between pages

Here's a simple example on two pages:


<div class="example example-1 example-simple">
    <div class="crop">
        <div class="level level-1">Level1</div>
        <div class="level level-0">Level0</div>
    </div>
    <div class="title">Sliding effect between two pages in CSS</div>
    <script>
        var open = false
        setInterval(function() {
            document.querySelector('.example-1 .level-0').classList[open ? 'add' : 'remove']('current')
            document.querySelector('.example-1 .level-1').classList[open ? 'remove' : 'add']('current')
            open = !open
        }, 1400)
    </script>
</div>


Here's our CSS code (basically):

```css
.level { transition: transform 1s linear; }

.level.level-0 { transform: translate(-100%, 0); }
.level.level-1 { transform: translate(+100%, 0); }

.level.current { .translate(0, 0); }
```

To get this result we toggle `current` class alternatively on `.level-0` and `.level-1`.


##Adding other levels

Now we have a two levels's animation working we might want to add a third level, things start to be more difficult.
Using CSS code of previous example, here's a 3 levels animation:

<div class="example example-2 example-simple">
    <div class="crop">
        <div class="level level-0">Level0</div>
        <div class="level level-1">Level1</div>
        <div class="level level-2">Level2</div>
    </div>
    <div class="title">Sliding effect between three pages in CSS (not working yet)</div>
    <script>
        var i = 0
        setInterval(function() {
            document.querySelector('.example-2 .level-0').classList[i === 0 ? 'add' : 'remove']('current')
            document.querySelector('.example-2 .level-1').classList[(i === 1 || i === 3) ? 'add' : 'remove']('current')
            document.querySelector('.example-2 .level-2').classList[i === 2 ? 'add' : 'remove']('current')
            i++
            if (i == 4) i = 0
        }, 1400)
    </script>
</div>

There's a glitch, do you see it ? __level 1__ always slides on the right, it should slides 
one time on the left the other time on the right. To achieve this we need to figure out the good
sliding direction (left or right). However the problem only applies to __level 1__ because __level 0__ and __level 2__ 
always slide on the same direction.

For __level 1__, if current level is higher we need to slide it left, else slide it right. Here're our 
rules graphically represented:

<div class="example example-3">
    <div class="crop crop-right example-down">
        <div class="level level-2">Level2</div>
        <div class="level level-1">Level1</div>
        <div class="level level-0">Level0</div>
    </div>
    <div class="crop crop-left example-up">
        <div class="level level-2">Level2</div>
        <div class="level level-1">Level1</div>
        <div class="level level-0">Level0</div>
    </div>
    <div class="title title-right">Going to lower level (slide right)</div>
    <div class="title title-left">Going to higher level (slide left)</div>
    <script>
        var j = 0
        setInterval(function() {
            document.querySelector('.example-up').classList.remove('step-0')
            document.querySelector('.example-up').classList.remove('step-1')
            document.querySelector('.example-up').classList.remove('step-2')
            document.querySelector('.example-up').classList.add('step-' + j)

            document.querySelector('.example-down').classList.remove('step-0')
            document.querySelector('.example-down').classList.remove('step-1')
            document.querySelector('.example-down').classList.remove('step-2')
            document.querySelector('.example-down').classList.add('step-' + j)

            j++
            if (j === 3) j = 0
        }, 1400)
    </script>
</div>


## Determine sliding direction

One simple rule four our HTML structure, lower levels are before higher levels:

```html
<!-- good -->
<div class="level-1"></div>
<div class="level-2"></div>
<div class="level-3"></div>

<!-- bad (level2 should be before level3) -->
<div class="level-1"></div>
<div class="level-3"></div>
<div class="level-2"></div>
```



To determine sliding direction of a level we need to determine if current level is higher or lower. And following
our HTML structure if current level is higher then it's a next sibling else a previous sibling.


To match preceding elements we use [`~` selector](http://www.w3.org/TR/selectors/#general-sibling-combinators).
But there's no CSS3 selector to match elements followed by an other. Fortunately we can never repeat it often enough, 
"C" in CSS stands for cascading, we can assume by default, every level is followed by current level, then match other cases.


Still keeping our example with __level 1__ (respective selector is `.level-1`), 3 cases:


- current level is higher - slide it left - CSS selector is `.level-1` [use cascading]
- current level is same - keep it centered - CSS selector is `.level-1.current`
- current level is lower - slide it right - CSS selector is `.current ~ .level-1 `


Our CSS now become:

```css
/* match .level-1 when current level is higher */
.level-1 { transform: translateX(-100%); }

/* match .level-1 when current level is same */
.level-1.current { transform: translateX(0%); }

/* match .level-1 when current level is lower */
.current ~ .level-1 { transform: translateX(100%); }

```

And our previous example is now working:

<div class="example example-4 example-working">
    <div class="crop">
        <div class="level level-0">Level0</div>
        <div class="level level-1">Level1</div>
        <div class="level level-2">Level2</div>
    </div>
    <div class="title">Sliding effect between three pages in CSS</div>
    <script>
        var k = 0
        setInterval(function() {
            document.querySelector('.example-4 .level-0').classList[k === 0 ? 'add' : 'remove']('current')
            document.querySelector('.example-4 .level-1').classList[(k === 1 || k === 3) ? 'add' : 'remove']('current')
            document.querySelector('.example-4 .level-2').classList[k === 2 ? 'add' : 'remove']('current')
            k++
            if (k == 4) k = 0
        }, 1400)
    </script>
</div>


## Adding Less godness

Now we have a fully working animation we might want to know if it's robust. Is adding 
a new level automatically managed ? Short answer: no, you have to write 3 css rules for each level, so 
we might consider using Less to avoid code duplication.


First thing to know is the creation of a loop using less, here's an example:

```css
// loop range
@maxLevel: 2;
@minLevel: 0;

// defining a "level" mixin
.level (@level) when (@level > @minLevel - 1) {

    // create a dynamic selector with our "level" variable
    .level-@{level} { color: red; }

    // recursion, calling our "level" mixin a level lower, etc..
    .level(@level - 1);
}

.level(@maxLevel);
```

Compiling above Less into CSS, will generate:


```css
.level-2 { color: red; }
.level-1 { color: red; }
.level-0 { color: red; }
```

Now going back to our animation, we can define following mixin:

```css
@maxLevel: 3;
@minLevel: 0;


.level-higher (@level) when (@level < @maxLevel) {
    .level-@{level} { transform: translateX(-100%); }
}

.level-same (@level) when (@level > @minLevel - 1) {
    .level-@{level}.current { transform: translateX(0%); }
}

.level-lower (@level) when (@level > @minLevel) {
    .current ~ .level-@{level} { transform: translateX(100%); }
}


.level (@level) when (@level > @minLevel - 1) {
    // recursion
    .level(@level - 1);

    .level-higher(@level);
    .level-same(@level);
    .level-lower(@level);
}

// start loop
.level(@maxLevel);
```

Compiling above Less into CSS will generate:

```css
.level-0 {              transform: translateX(-100%); }
.level-0.current {      transform: translateX(0%); }

.level-1 {              transform: translateX(-100%); }
.level-1.current {      transform: translateX(0%); }
.current ~ .level-1 {   transform: translateX(100%); }

.level-2.current {      transform: translateX(0%); }
.current ~ .level-2 {   transform: translateX(100%); }
```

<div class="alert warning">
    In this example we're using <code>transform</code> and <code>transition</code> properties, be sure to also include  prefixed versions.
    See <a href="https://github.com/twitter/bootstrap/blob/master/less/mixins.less#L258"<code>transition()</code> mixin</a> and
    <a href="https://github.com/twitter/bootstrap/blob/master/less/mixins.less#L293"><code>translate()</code> mixin</a>.
</div>

Now you're done, we can now adjust `@maxLevel` to suit our needs.
[See fully working example](/assets/examples/mobile-layout.html)
