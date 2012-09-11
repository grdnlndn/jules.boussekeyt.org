---
layout: post
tags: backend
title: How to deal with multiple timezones in php
---


> A time zone is a region on Earth, more or less bounded by lines of longitude, that has a uniform, legally mandated standard time, usually referred to as the local time.

##Why you may have to set a default timezone while creating a web app ?

###To avoid warnings when dealing with dates

While using the date() function if your timezone isn't correctly set you will receive a warning like this:

> It is not safe to rely on the system's timezone settings. You are *required* to use the date.timezone setting or the date_default_timezone_set() function. In case you used any of those methods and you are still getting this warning, you most likely misspelled the timezone identifier.

So the PHP interpreter makes sure you are not basing your date-based calculations while relying upon the system's timezone settings.

###To correctly manage timezones !

A great thing about web-based applications is that they can be accessible and usable throughout the world and this means people from varying timezones will be accessing your application at the same time. They must be able to perform the date-based functions relative to a standard time zone to avoid confusion and miscalculations.  This is more so important when it is very critical to trigger particular actions based on local as well as international timings.

![Timezones World Map](/assets/images/2010-deal-with-timezone-php/timezone.jpg)

Coming back to the PHP part. It's not really difficult to deal with timezones in PHP. But there's some common mistakes that you can avoid with simple tips.

##Set the default timezone

You can set your default timezone in two ways: let us assume "Europe/Paris" is the time zone you want to set:

- Open your php.ini file in your favourite text editor and change the following line: `date.timezone = Europe/Paris`. You may have to restart your server in order to make this effective.
- In case you don't want to meddle with your ini file you can simply set the default time zone using the following PHP function: 

{% highlight php %}
<?php date_default_timezone_set('Europe/Paris') ?>
{% endhighlight %}

[List of PHP supported Timezones](http://www.php.net/manual/en/timezones.php)

##Update your timezones

Your php installation uses the timezonedb package available on PECL.

You can check the current version of your timezonedb with:


{% highlight php %}
<?php echo timezone_version_get() ?>
{% endhighlight %}

You will see a number like this 2012.9 wich correspond to a date.

Sometime timezones are updated, if the package is older than one year, i suggest you update your timezonedb.

You can install/update your timezonedb version by executing the following command on the terminal:

{% highlight bash %}
$ sudo pecl install timezonedb
{% endhighlight %}

Don't forget to add the new extension to php.ini and then restart your server in order to make this effective.

`extension=timezonedb.so`

##Get the User Timezone

###Let the user pick it

With the above function you have all timezones listed by continents. You can then create a drop down menu for continents and option for each country. [See an example here](/examples/timezone/timezone_options.php).

{% highlight php %}
<?php

function timezone_options()
{
    $zones = array(
        'Africa', 'America', 'Antarctica', 'Arctic', 'Asia',
        'Atlantatic', 'Australia', 'Europe', 'Indian', 'Pacific'
    );

    $list = timezone_identifiers_list();
    foreach ($list as $zone) {
        list($zone, $country) = explode('/', $zone);
        if (in_array($zone, $zones) && isset($country) != '') {
            $countryStr = str_replace('_', ' ', $country);
            $locations[$zone][$zone.'/'.$country] = $countryStr;
        }
    }

    return $locations;
}
{% endhighlight %}

###Get it via Javascript and PHP

> Time zone are written as offset from UTC in the format ±[hh]:[mm], ±[hh][mm], or ±[hh]. So if the time being described is one hour ahead of UTC (such as the time in Berlin during the winter), the zone designator would be "+01:00", "+0100", or simply "+01".

You can't directly access to the user timezone via Php. To get the user timezone you have to get his offset and to know if saving daylight is observed. You can use JavaScript to obtain this information. [See an example here](/examples/timezone/timezone_javascript.php):

{% highlight javascript %}
function get_timezone_infos() {
    var now = new Date();
    var jan1 = new Date(now.getFullYear(), 0, 1, 0, 0, 0, 0);
    var temp = jan1.toGMTString();
    var jan2 = new Date(temp.substring(0, temp.lastIndexOf(' ') - 1));
    var offset = (jan1 - jan2) / (1000);

    var june1 = new Date(now.getFullYear(), 6, 1, 0, 0, 0, 0);
    temp = june1.toGMTString();
    var june2 = new Date(temp.substring(0, temp.lastIndexOf(' ') - 1));
    var dst = offset != ((june1 - june2) / (1000));

    return { offset: offset, dst: dst };
}
{% endhighlight %}

##Database Storage

First most, it's not really difficult to store dates in a database. My prefered choice is the MySQL dateTime field, where you can store date and time in one field.

<div class="alert warning">
You must store the DateTime in UTC timezone for all columns of DateTime type.
</div>


Set the DateTime timezone to UTC before storing it in the database:

{% highlight php %}
<?php

function toDatabase($dateTime)
{
    $dateTime->setTimezone(new DateTimeZone('GMT'));
    return $dateTime;
}
{% endhighlight %}

When retrieving the DateTime from the database set it to the original timezone:

{% highlight php %}
<?php

// set the timezone of the current user before calling the function
date_default_timezone_set('Europe/Paris');
{% endhighlight %}

{% highlight php %}
<?php

function toUser($dateTime)
{
    $dateTime->setTimezone(new DateTimeZone(date_default_timezone_get()));
    return $dateTime;
}
{% endhighlight %}

