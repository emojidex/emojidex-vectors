!Warning!
=========
If you are reading this, chances are you don't need to use any of the utilities provided here. 
They are mainly for internal use. There are no detailed instructions, nor do we have plans 
of providing documentation. If you've got a specific idea and want help implementing it please 
feel free to consult us/ask for help on the github issue tracker for emojidex-vectors.

About these Utilities
=====================
This is a small collection of tools specifically to manipulate the SVG/vector data files that are 
the base of the emojidex emoji assets. Compiled versions of these assets will always be available 
on in this repository in the emoji/utf and emoji/extended folders.

Generators
==========
Variants
--------
Variants are emoji which have multiple versions [variants] with a common component. The best 
example of this would be faces where there are mutliple backings but the eyes and mouth would be 
the same (EG: starry_eyed, starry_eyed(p), starry_eyed(bk)).

Combinations
------------
Combinations are emoji that can be combined in a variety of ways. The combinations folder in src 
contains the base components for these combinations. The combination generator generates all the 
non-combined bases (EG: 'family', 'family(ye)'...) and copies all relevant individual components 
(eg man(p), heart, woman(ye)) for ZWJ sequences and other combinations to be assembled on/by 
user end clients.

Animation Updator
=================
The animation updator just updates the animated emoji from their frame sources in the utf and 
extended folders.

You will note the "update_animations" script is not labeled as a generator, desptie the fact that 
it technically is. There is a very specific reason for this distinction: animations (and compiled 
components) are distributed within the utf and extended folders in this repository and on the 
CDN. Because of this, each source frame of the animation can be used individually and can be 
considered a singular complete source image on its own, and a compiled animation correlating to 
each set of animated sources can be found within the parent folder of the animation sources. 
To put it another way, generators assemble components together whereas the updator combines 
alerady assembled sources.

Notes
=====
ALWAYS run "update_animations" AFTER a lint. Inkscape kills the animations.
