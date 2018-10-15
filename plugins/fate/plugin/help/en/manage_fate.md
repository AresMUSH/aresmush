---
toc: Fate Skills
summary: Managing Fate skills.
---

# Managing Fate

Admin can set abilities manually and award fate points.

## Fate Points

Fate points in the core mechanic are refreshed every "session".  You'll need to decide what constitutes a "session" for your game and trigger the refresh accordingly.  Some games may do a refresh monthly; others may do so after a natural break in the metaplot.  It's up to you.

`fate/award <name>=<points>` - Awards fate points to a character.
`fate/refresh` - Refreshses everyone's fate points.  

## Abilities

Admins with the `manage_apps` permission can set other character's abilities.  Since Fate does not have a built-in XP mechanic, you'll need to use these commands when it's appropriate to let people advance.

`aspect/add <name>=<aspect name>` - Adds an aspect.
`skill/set <name>=<skill name>/<rating>` - Sets a skill.
`stunt/add <name>=<stunt name>` - Adds a stunt.
`stunt/remove <name>=<stunt name>` - Removes a stunt.

Set a skill rating to 0 to remove an ability.