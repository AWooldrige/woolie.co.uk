---
title: "Getting CodeMirror vim bindings working in TiddlyWiki"
created_at: 2020-01-16 17:44:00 +0000
updated_at: 2020-01-21 07:13:00 +0000
kind: article
excerpt: >-
    Getting CodeMirror vim bindings working in TiddlyWiki took more steps than
    I'd expect. Here's how to do it.
---

## Instructions
1. Install the following plugins at minimum:
    1. `CodeMirror _Editor`
    2. `CodeMirror Keymap: Vim`
    3. `CodeMirror AddOn: Close Brackets`: this is a requirement for
       `CodeMirror Keymap: Vim`.
    4. `CodeMirror AddOn: Search and Replace`: this is a requirement for
       `CodeMirror Keymap: Vim`.
2. Change the CodeMirror keymap to vim in TiddlyWiki settings.
3. Remove/re-bind existing TiddlyWiki keyboard shortcuts that mask vim
   commands. In the "Keyboard Shortcuts" section of the control panel, unset:
   1. `cancel-edit-tiddler`- which masks the `escape` key.
   2. `underline` which masks the r`ctrl-u` mapping.
4. Optional: disable CodeMirror when using mobile browser. Instructions in "Not
   usuable on mobile" section below.


## Problems

### TypeError: n is undefined
Make sure `CodeMirror AddOn: Close Brackets` and `CodeMirror AddOn: Search and
Replace` are installed. See [TW issue
3413](https://github.com/Jermolene/TiddlyWiki5/issues/3413) for details.

### Not usable on mobile
Aside from the vim bindings being fairly unhelpfuly when you only have a mobile
keyboard handy, CodeMirror itself has flaky mobile support. When using
TiddlyWiki from an iOS device, the press and hold text selection doesn't work
inside CodeMirror. There's no way to cut/copy and paste either.

To fix this, I prefer TiddlyWiki to disable CodeMirror entirely when it detects
a mobile browser. To do this, `buggyj` kindly wrote a plugin which is available
in a comment on [TiddlyWiki GitHub issue #2730](https://github.com/Jermolene/TiddlyWiki5/issues/2730). For those too
lazy to head to that issue, here is how to manually add the plugin:

1. Create a new tiddler with the title: `$:/core/modules/macros/hackeditorstring.js`
2. Set the tiddler type to: `application/javascript`
3. Add a new field to the tiddler with:
  * Field name: `module-type` (**not** `plugin-type` that's in the dropdown)
  * Field value: `startup`
4. Set the tiddler content to:


Plugin body:

    /*\
    title: $:/core/modules/macros/hackeditorstring.js
    type: application/javascript
    module-type: startup


    \*/
    (function(){

    /*jslint node: true, browser: true */
    /*global $tw: false */
    "use strict";

    // Export name and synchronous status
    exports.name = "hackeditstring";
    exports.after = ["load-modules"];
    exports.synchronous = true;


    exports.startup = function() {


    if ($tw.browser)
    if (/Android|webOS|iPhone|iPad|iPod|Opera Mini/i.test(navigator.userAgent || navigator.vendor || window.opera)) {
            $tw.wiki.addTiddler(new $tw.Tiddler({title: "$:/config/EditorTypeMappings/text/vnd.tiddlywiki", text: "text"}));
                }
    else {
            $tw.wiki.addTiddler(new $tw.Tiddler({title: "$:/config/EditorTypeMappings/text/vnd.tiddlywiki", text: "codemirror"}));
    }
    }

    })();


