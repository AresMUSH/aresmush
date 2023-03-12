---
toc: ~admin~ Managing the Game
summary: Managing FS3 Skills.
aliases:
- manage_abilities
- manage_fs3
---
# Managing FS3 Skills

> **Permission Required:** These commands require the Admin role or the permission: manage\_abilities

Those with the proper permissions can adjust skills, luck and XP.

## Viewing Sheets

Some games may have multiple pages of the character sheet, and some pages might be configured to be private.  Private sheets can only be viewed by people with the `view_sheets` permission.

`sheet <name>` - View someone else's sheet.

## Roll Results

Roll results can be sent to a channel, configured in the FS3Skills settings.  Storytellers can join that channel in order to judge situations even without being in the room.  The roll command will also let you roll for other people, if storytellers prefer to roll something privately.

## Adjusting Skills

You can adjust skill levels:

`ability <name>=<ability>/<rating>` - Set someone else's ability.

To remove a skill, just set its rating to 0.

You can also adjust specialties:

`specialty/add <name>=<ability name>/<specialty>` - Set someone else's specialty.
`specialty/remove <name>=<ability name>/<specialty>` - Remove someone else's specialty.

## Awarding Luck

See [Manage Luck](/help/manage_luck).

## Managing XP

See [Manage XP](/help/manage_xp).

## Removing and Renaming Abilities

If you want to remove or rename an ability in your skills configuration, you need to update any existing characters. Two commands can help with this:

`wipeability <name>` - Will remove an ability from **ALL** characters. Checks all ability types (action/bg/lang/adv).
`renameability <old name>=<new name>` - Will rename an ability for **ALL** characters. Checks all ability types (action/bg/lang/adv).

If you need to do more sophisticated processing (such as moving an ability from an action skill to a background skill or vice-versa), it will require custom code. See [Changing Existing Abilities](https://aresmush.com/tutorials/config/fs3skills_skills.html#changing-an-existing-ability) in the FS3 config help.
