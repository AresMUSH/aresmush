---
toc: FS3
summary: Managing skills and luck.
---
# Managing FS3

> **Permission Required:** These commands require the Admin role or the permission: manage\_abilities

Those with the proper permissions can adjust skills, luck and XP.

## Viewing Sheets

Some games may have multiple pages of the character sheet, and some pages might be configured to be private.  (See [Configuring FS3](/help/fs3skills/config) for more information.)

Private sheets can only be viewed by people with the `view_sheets` permission.

## Roll Results

Anyone with the `receives_roll_results` permission will see a message whenever someone rolls an ability.  This allows you to judge situations even without being in the room.

## Adjusting Skills

You can adjust skill levels:

`ability <name>=<ability>/<rating>`

To remove a skill, just set its rating to 0.

## Awarding Luck

You can award luck points.

`luck/award <name>=<number of luck points>`

## Managing XP

You can award XP and view someone's XP display.

`xp/award <name>=<# of XP>/<reason>` - Awards XP.
`xp <name>` - Views someone's XP progress.