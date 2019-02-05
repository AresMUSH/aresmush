---
toc: Setting Up Your Client
summary: Grabbing and editing text from the game.
aliases:
- grab
- FugueEdit
- decompile
- editing
---
# Editing Game Text

AresMUSH doesn't support the old `/grab object/attribute` syntax you may be familiar with from Penn and TinyMUX, because its database works differently.  However, many commands support an `/edit` switch, which allows you to easily grab game text into your client's input buffer (the place where you type).  For example, typing `desc/edit me` will put your description into your input buffer so you can edit it and send it right back.

The edit feature only works if your MU client supports grab/FugueEdit functionality.  When the client sees text with a special prefix in front, it sends the text to your input buffer instead of to your screen.  

The default prefix is `FugueEdit >`, a long-standing MUSH tradition.  This will work by on many clients, but some require you to set a different prefix (sometimes called a "grab password").  To do this:

`edit/prefix <prefix>` - Sets your grab/edit prefix.

Some clients also require special setup.  See the [AresMUSH Client Configuration Tutorial](http://aresmush.com/clients) for more information.
