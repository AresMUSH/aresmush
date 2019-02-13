---
toc: ~admin~ Managing the Game
summary: Managing FS3 Skills.
aliases:
- ability set
- xp award
- xp undo
---
# Managing FS3 Skills

> **These commands require the Admin role or the permission: manage\_abilities**

## Roll Results

Roll results can be sent to a channel.  Storytellers can join that channel in order to judge situations even without being in the room.  The roll command will also let you roll for other people, if storytellers prefer to roll something privately.

## Adjusting Skills

`ability <name>=<ability>/<rating>` - Adjust a skill level. To remove a skill, set its rating to 0.

`specialty/add <name>=<ability name>/<specialty>` - Add a specialty.
`specialty/remove <name>=<ability name>/<specialty>` - Remove a specialty.

## Awarding Luck & XP

`luck/award <name>=<number of luck points>/<reason>` - Award luck points. This will take decimals (.5), but not fractions (1\/2).

`xp/award <name>=<# of XP>/<reason>` - Awards XP.
`xp <name>` - Views someone's XP progress.

If someone accidentally spends XP on the wrong skill, you can use the 'undo' command.  This will refund them 1XP and reset the learning time on the incorrect skill.  If the XP had resulted in a skill raising a level, this command will reduce the skill level.

`xp/undo <name>=<ability>` - Undo an accidentaly XP expenditure.
