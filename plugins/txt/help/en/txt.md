---
toc: Playing the Game
summary: How to send HoloTxts.
aliases:
- sms
- text

---
# Text Messaging

`txt <target>=<message>` - Send a message to target.
`txt =<message>` - Send a message to your last target.

`txt <target>/<scene #>=<message>` - Send a text to a target + log it into a scene.

`txt/color <color>` - Color the (Txt) prefix. Use ansi color format for this, ex: \%xh\%xr for red highlight, \%xh\%xg for green highlight.

> If you do not wish to receive txts (in general, or from a specific person), the `page/ignore <name>=<on/off>` and `page/dnd <on/off>` commands will block txts as well.

Credit for txt code to Skew@AresCentral
