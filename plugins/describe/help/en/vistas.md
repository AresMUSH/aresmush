---
toc: ~admin~ Building
summary: Expanding room descriptions by time and season.
---
# Vistas

Vistas allow you to have a catalog of room descriptions, much the same way that you can have multiple outfits for a character.  The base description is set via the `describe` command.  Then you have vistas that are added to that based on the time of day (morning, day, evening, night) and season (spring, summer, fall, winter).

All vistas are optional.  Think of them like building blocks.  If your room only has a 'night' vista and a 'summer' vista, then the description would be:

* On a summer night:  `[base desc] [night desc] [summer desc]`
* On a summer day:  `[base desc] [summer desc]`
* On a spring/fall/winter night:  `[base desc] [night desc]`
* Any other time:  `[base desc]`

> The weather condition is also appended to the description if the weather system is enabled.

`vistas <name>` - Shows vistas.
`vista/set <name>=<vista title>/<description>` - Creates or updates a vista.
`vista/delete <name>/<vista title>` - Deletes a vista.
`vista/edit <name>/<vista title>` - Grabs the existing detail into your input buffer.