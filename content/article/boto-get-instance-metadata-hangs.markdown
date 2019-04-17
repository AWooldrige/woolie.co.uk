---
title: Boto get_instance_metadata Hangs When Not on EC2
created_at: 2014-01-06 17:30:00 +0000
kind: article
excerpt: >-
    Boto's get_instance_metadata can hang when run on a non-EC2 machine. Find
    out how to workaround this.
---

### The Symptom
The following script hangs if ran on a machine which isn't an EC2 instance:

    #!/usr/bin/env python
    from boto.utils import get_instance_metadata
    get_instance_metadata()


### Why Does it Hang?
`get_instance_metadata` makes a HTTP call to the instance metadata service. This service is inaccessible outside of AWS so the `socket` library hangs trying to make the connection.  Normally you would expect this connection to timeout, but by default the timeout is set to `None` so it will wait forever.


### How to Fix It
The fix is simply to reduce the timeout:

    #!/usr/bin/env python
    from boto.utils import get_instance_metadata
    get_instance_metadata(timeout=2, num_retries=2)


Notes:

 * You'll notice that even though `timeout=2` and `num_retries=2`, the script takes much longer than expected to exit. This is because boto sleeps exponentially after every failed connection.
 * `num_retries` isn't quite correct either: setting `num_retries=0` results in no connection attempts ever being made. It should be renamed to `num_attempts` or fixed!
