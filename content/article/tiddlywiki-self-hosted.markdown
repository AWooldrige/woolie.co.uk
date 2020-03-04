---
title: "Self-hosting notes with a Raspberry Pi and TiddlyWiki"
created_at: 2020-03-04 07:22:00 +0000
updated_at: 2020-03-04 07:22:00 +0000
kind: article
excerpt: >-
    Self-hosted note taking with a Raspberry Pi, TiddlyWiki and encrypted
    backups.
---


## Why not just use Evernote?
Over the years I've trusted numerous third party services for note taking, but
none have quite cut the mustard. [Evernote](https://evernote.com/) was the
first and I persevered with it for many years. It's feature set is adequate,
the note search is snappy and the price _just_ about acceptable. But there's
one reason that I felt an urge to stop using it - at the time, note data was
stored unencrypted on Evernote's servers. Even now, they use Google supplied
encryption at rest, but unless I'm the one the has the encryption keys, I won't
be satisfied. Although I'm sure they have a top notch security team, but if
someone else has my encryption keys, that doesn't give me a warm fuzzy feeling.

Then I tried [Bear](https://bear.app/). Bear is a fine example of software done
right. Its interface is majestic, the feature set complete and it doesn't lock
your notes into a proprietary format. App performance is blazingly fast due to
their deep integration with Apple provided SDK interfaces. But their deep
integration with Apple is also their downfall for me. Bear only supports MacOS
and iOS. My home machine and laptop are Linux only, for which there is no way
to use Bear.


## Self-hosted TiddlyWiki architecture
[TiddlyWiki](https://tiddlywiki.com/) is fully featured JavaScript wiki that
runs as a single HTML file. My first tinkering with TiddlyWiki was in 2008 (12
years ago at time of writing) and I was pleasantly surprised to still see the
project active in 2020. Immediate credibility points there!

Although TiddlyWiki does its job well, it does require some ancillary services
to fully meet requirements for a note taking system. I use the Node.js server
version of TiddlyWiki, which makes the wiki available in a client/server saving
model rather than being entirely client side. Here is how I host it on a home
Raspberry Pi:


    +=================================+===================================+
    |        HTTP REQUEST FLOW        |         ANCILLARY COMPONENTS      |
    +=================================+===================================+
                     _
                    ( )                     +---------------------------+
                   ==|==                    |:: Amazon Route53 (DNS)    |
                     |    ---(DNS)--------->|                           |
                    / \                     |   Updated with home IP    |
                                            +---------------------------+
                     |                                    ^
    +----------------|------------------------------------|---------------+
    |                v                                    |               |
    |  +--------------------------+         +--------------------------+  |
    |  |:: nginx (gateway)        |         |:: DNS updater (cron)     |  |
    |  |                          |         |                          |  |
    |  |   TLS + HTTP basic auth  |         |   Public IP checker      |  |
    |  +--------------------------+         +--------------------------+  |
    |                |                                                    |
    |                v                                                    |
    |  +--------------------------+                                       |
    |  |:: TiddlyWiki (Node.js)   |                                       |
    |  |                          |         +--------------------------+  |
    |  |   Systemd managed        |         |:: Versioning (cron)      |  |
    |  +------------- ------------+         |                          |  |
    |               | |                +----|   Regular git add -A     |  |
    |               | |                |    +--------------------------+  |
    |  +------------| |-----------+    |    +--------------------------+  |
    |  |:: /var/tiddlywiki/       |<---+    |:: Backup (cron)          |  |
    |  |                          |         |                          |  |
    |  |   Note storage + git     |-------->|   Duplicity with GPG     |  |
    |  +--------------------------+         +--------------------------+  |
    |                                                     |               |
    +-----------------------------------------------------|---------------+
     Raspberry Pi, managed by Puppet.                     v
                                            +---------------------------+
                                            |:: Amazon S3 (Backups)     |
                                            |                           |
                                            |   GPG encrypted           |
                                            +---------------------------+

Which means I can access my notes from anywhere, securely:


<div class='gallery'>
<%=
    imageVerbatim(
        item.identifier.without_ext + '/example-from-home-tiddlywiki.png',
        caption=true
    )
%>
</div>


## Self-hosting component detail

TiddlyWiki serving components:

 * **nginx**: Provides TLS termination with Let's Encrypt certificates and HTTP
   Basic Authorisation, then proxies to TiddlyWiki.  [See nginx config](https://github.com/AWooldrige/puppet/blob/master/modules/raspi/files/sites-available/cg.wooldrige.co.uk).
 * **TiddlyWiki**: Node.js version of TiddlyWiki, listening on loopback only
   and configured with lazy image loading and gzip enabled. Running as a
   system service - [see systemd unit
   file](https://github.com/AWooldrige/puppet/blob/20b9fc8d237498ba3747dd9a1d921cae3aaff524/modules/raspi/files/tiddlywiki/tiddlywiki-ww.service).
 * **/var/tiddlywiki/**: Storage area for TiddlyWiki notes, initialised as a git repo.
 * **Versioning**: A cron job that runs `git add --all` every hour inside
   `/var/tiddlywiki/`. See [the script](https://github.com/AWooldrige/puppet/blob/adb1de64b3707fe0c48d56536797a9f9cfd16400/modules/raspi/files/tiddlywiki/tiddlywiki-ww-gitadd).
 * **Backups**: Daily cron job to backup `/var/tiddlywiki/` to S3 using
   Duplicity with symmetric GPG encryption. See [the
   backup script](https://github.com/AWooldrige/puppet/blob/adb1de64b3707fe0c48d56536797a9f9cfd16400/modules/raspi/files/tiddlywiki/tiddlywiki-ww-backup) and [the
   restore script](https://github.com/AWooldrige/puppet/blob/adb1de64b3707fe0c48d56536797a9f9cfd16400/modules/raspi/files/tiddlywiki/tiddlywiki-ww-backup).



Raspberry Pi management:

 * **DNS updater**: To work around ISPs that don't provide static IPs.  The
   script determines the currently assigned public IP, then updates a DNS A
   record in Route53 to point to it. See [the
   script](https://github.com/AWooldrige/puppet/blob/adb1de64b3707fe0c48d56536797a9f9cfd16400/modules/ddns/files/ddns).
 * **Puppet**: Puppet is used for configuration management. All of my manifest
   and modules are [publically available
   here](https://github.com/AWooldrige/puppet).


## Benefits, downsides and improvements

Benefits of this arrangement:

 * All notes are loaded in the browser. If the network decides to have a little
   wobbly, all notes are already present and searchable.
 * You can `grep`, `vim`  `sed` and `awk` notes on the server side.
 * A read-only offline copy is available. Just click the TiddlyWiki "Save
   Changes" button.

Downsides of this arrangement:

 * Self hosting means you're the one who has to fix things when they go wrong.
 * TiddlyWiki doesn't have the best UI support for when the network breaks
   down. Warning modals fly all over the place.
 * Although backups to S3 are encrypted, the data is unencrypted on the
   Raspberry Pi. This could be improved by using an encrypted partition for the
   storage, but even then that only mitigates physical theft.

Future enhancements:

 * Patch TiddlyWiki to support listening on a Unix Domain Socket. There are
   minor performance and security reasons for this.
