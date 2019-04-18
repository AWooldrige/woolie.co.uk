---
title: Install biblatex for use with Kile on Ubuntu
created_at: 2010-09-21 13:39:27 +0000
updated_at: 2010-09-21 13:39:27 +0000
kind: article
Legacy WP ID: 446
excerpt: >-
    Installing biblatex for using with the Kile editor is easier than you
    think.
---
A good hour of my time has been wasted today trying to manuallly install
biblatex. When trying to compile a document with Kile it choked up `File
'biblatex.sty' not found.`, evidentially because the package wasn't installed.

I downloaded biblatex from CTAN, followed the README about halfway (which took
a while) and then lost interest. I resorted to Google, desperate for a quicker
way. Luck fell my way, I stumbled on something I'd missed during the previous
hour of Googling:

    sudo apt-get install biblatex

There's a package in the repository for it. Great. I hope this post saves you
the hour of searching I lost today!
