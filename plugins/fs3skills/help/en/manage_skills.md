---
toc: ~admin~ Managing the Game
summary: Managing FS3 Skills.
aliases:
- ability set
- xp award
- xp undo
---
# Managing FS3 Skills

> **Permission Required:** These commands require the Admin role or the permission: manage\_abilities

Those with the proper permissions can adjust skills, luck and XP.

## Viewing Sheets

Some games may have multiple pages of the character sheet, and some pages might be configured to be private.  Private sheets can only be viewed by people with the `view_sheets` permission.

`sheet <name>`

## Roll Results

Roll results can be sent to a channel, configured in the FS3Skills settings.  Storytellers can join that channel in order to judge situations even without being in the room.  The roll command will also let you roll for other people, if storytellers prefer to roll something privately.

## Adjusting Skills

You can adjust skill levels:

`ability <name>=<ability>/<rating>`

To remove a skill, just set its rating to 0.

You can also adjust specialties:

`specialty/add <name>=<ability name>/<specialty>`
`specialty/remove <name>=<ability name>/<specialty>`

## Awarding Luck

You can award luck points.

`luck/award <name>=<number of luck points>/<reason>`

## Managing XP

You can award XP and view someone's XP display.

`xp/award <name>=<# of XP>/<reason>` - Awards XP.
`xp <name>` - Views someone's XP progress.

If someone accidentally spends XP on the wrong skill, you can use the 'undo' command.  This will refund them 1XP and reset the learning time on the incorrect skill.  If the XP had resulted in a skill raising a level, this command will reduce the skill level.

`xp/undo <name>=<ability>` - Undo an accidentaly XP expenditure.