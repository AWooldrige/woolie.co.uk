---
title: "Markup test: article"
created_at: 2019-04-10 06:56:00 +0000
kind: article
sitemap: false
---

<p class="lead" markdown="1">
This is lead text
</p>


# H1 level heading - normal markup items
Example of a list:

 * Item number one is a fine item, but with some *stronger* text dotted in.
 * Item number two is a also fine item, but with some _emphasis_ text dotted in.
 * Item number three is a also fine item, but with both ***stronger emphasis*** dotted in.
 * Item number four has
    * A number of...
    * ...indented lists
        1. to check that the formatting doesn't fail
        2. when nesting
 * Item five has an embedded paragraph:

    Which should display inside the list item

 * Item six has an embedded code listing:

        Which should display inside the list item

This paragraph contains a line break here,  
by including two spaces at the end of the line.

There are some [links contained](http://www.example.com) within this paragraph,
some with [additional title text](# "I appear in a tooltip!"). We are also able
to create [referenced][1] links to not interrupt the flow of the markdown.

[1]: <https://www.example.com/> "Example reference"

## H2 level heading - code markup items
I add this to my `.bash_profile`:

    #!/usr/bin/env bash
    set -eu
    yes no

Although


### H3 level heading - some quotes
First and second lines read, with a third line embedded:

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
> tempor incididunt ut labore et dolore magna aliqua.
>
> Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
> aliquip ex ea commodo consequat.
>
> - A
> - B
>
>> Duis aute irure dolor in *reprehenderit* in voluptate velit esse cillum
>> dolore eu fugiat nulla pariatur.

Swiftly followed by a horizontal rule

---

That breaks up our flow.


### H4 level heading - image time
Time to get some images involved. First off, a 1980px width image included
verbatim, without any nanoc filters.

<%=
imageVerbatim(
    item.identifier.without_ext +
    '/bloom-blossom-close-up.jpg'
)
%>

Next up, two images filtered down for size, both with captions (well not yet)
and on the same row:

<div class='gallery'>
<%=
imageThumbnail(
    item.identifier.without_ext +
    '/bump-collaboration-colleagues.jpg',
    :w550
)
%>
<%=
imageThumbnail(
    item.identifier.without_ext +
    '/camera-coffee-composition.jpg',
    :w550
)
%>
</div>


### H5 level heading
Para

### H6 level heading
Para
