---
title: Make Full GET Request But Only Display Headers - cURL
created_at: 2014-10-30 17:20:00 +0000
updated_at: 2014-10-30 17:20:00 +0000
kind: article
excerpt: >-
    Sometimes, you'd like to cURL to make a GET request but only show the
    response headers. This article shows how to do that, without issuing an
    HTTP HEAD.
---

#### TL;DR - Here's the command


    curl -IXGET http://example.com/file.txt


which produces:

    $ curl -IXGET http://www.woolie.co.uk
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=UTF-8
    Content-Length: 1662
    Cache-Control: max-age=3600
    Content-Encoding: gzip
    ETag: "491e3f837bca4470f09871ab186a93a7"



---------------------------------------



### For the curious - What does IXGET do?

The `-IXGET` argument stumped me for a while, mainly because my brain was
parsing `-IXGET` as one argument. It's actually layering 2 arguments:

* `-I` - tells cURL to make a HEAD request. Delving through the [source
  code](https://github.com/bagder/curl/blob/f29b88c2467da1d4e55c19d6212b5ac992ffcfb8/src/tool_operate.c#L844) shows adding this argument does nothing more than set the following CURLOPTs:
    * [CURLOPT_NOBODY](http://curl.haxx.se/libcurl/c/CURLOPT_NOBODY.html) sets
      the request method to HEAD and ignores the response body if any was sent.
    * [CURLOPT_HEADER](http://curl.haxx.se/libcurl/c/CURLOPT_HEADER.html)
      makes cURL print the response headers in the body output.
* `-X` - allows you to dumbly overwrite the HTTP request method sent with the request, in our case replacing HEAD that `-I` triggered with GET.

If you feel like confusing a server, cURL doesn't sanity check `-X` and you can overwrite it with whatever you fancy:

    $ curl http://www.google.co.uk/ -XDONKEY -v -s -o /dev/null
    > DONKEY / HTTP/1.1
    > User-Agent: curl/7.37.1
    > Host: www.google.co.uk
    > Accept: */*
    >
    < HTTP/1.1 405 Method Not Allowed
    < Content-Type: text/html; charset=UTF-8
    < Content-Length: 1455
    < Server: GFE/2.0


### Other Methods of Achieving the Same

For years I'd always used the following cURL arguments to achieve the same as
`-IXGET`:

    curl -s -o /dev/null -D - http://example.com/file.txt

This asks to send all HTTP response body to `/dev/null` but to dump the
response headers to `stdout`.
