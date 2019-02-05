---
toc: ~admin~ Managing the Game
summary: Managing skills and luck.
aliases:
- xp award
- xp undo
---
# Managing FS3 XP

> **Permission Required:** These commands require the Admin role or the permission: manage\_abilities

Those with the proper permissions can award XP.

`xp/award <name>=<# of XP>/<reason>` - Awards XP.
`xp <name>` - Views someone's XP progress.

If someone accidentally spends XP on the wrong skill, you can use the 'undo' command.  This will refund them 1XP and reset the learning time on the incorrect skill.  If the XP had resulted in a skill raising a level, this command will reduce the skill level.

`xp/undo <name>=<ability>` - Undo an accidentaly XP expenditure.