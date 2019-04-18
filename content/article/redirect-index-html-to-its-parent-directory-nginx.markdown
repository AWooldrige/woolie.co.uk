---
title: Redirect index.html to its Parent Directory in Nginx
created_at: 2013-05-16 17:34:54 +0000
updated_at: 2013-05-16 17:34:54 +0000
kind: article
excerpt: >-
    An initial configuration step with many static websites is to ensure that
    the index.html is served whenever a directory path is requested.
---
I use nanoc to generate static sites which get served with nginx. The files and
directories produced have the following basic structure.

    ├── article
    │   └── example-article
    │       └── index.html
    │   └── another-article
    │       └── index.html
    └── index.html

A page (article) should only be served at one URL - a canoncial URL. By default
nanoc will serve the content at the two following URLs:

 * /article/example-article/index.html
 * /article/example-article/

I don't want that! The article should only be available at
/article/example-article/.

## First Stab - One Rewrite Rule
The initial rewrite I came up with was:

    rewrite ^(.*/)index.html$ $1 permanent;

This works great for the articles. Not so great for root resource which now
sits in an infinate redirect loop:

    $ curl -ILs --max-redirs 5 http://woolie.co.uk/ | grep Location
    Location: http://woolie.co.uk/
    Location: http://woolie.co.uk/
    Location: http://woolie.co.uk/
    Location: http://woolie.co.uk/
    Location: http://woolie.co.uk/

This is likely due to nginx's internal rewriting that it performs to serve the
index.html page. Being new to nginx, thats as far as my guesswork goes.

## Solution
The `$request_uri` variable always points to the URI from the original request.
We can use this in a control statement, as internal rewriting won't affect it.

    if ($request_uri ~ ^(.*/)index.html$) {
        return 301 $1;
    }
