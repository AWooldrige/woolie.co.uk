---
title: Line Breaks in Apache httpd Configuration Directives
created_at: 2014-10-23 17:40:00 +0000
kind: article
---

It's possible to split Apache httpd configuration directives over multiple
lines. Just use the backslash (`\`) to mark a continuation line like you'd do
in many languages and configruation formats.

For example use to break up a long ProxyPass:

    ProxyPass http://backend.example.com/a-long-path-to-demonstrate \
        connectiontimeout=1 retry=0

or CustomLog:

    CustomLog logs/ssl_request_log \
        "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"


I've been working with httpd for years, and can't believe I missed the [first
line in the guide](http://httpd.apache.org/docs/2.4/configuring.html#syntax) to
configuration syntax.
