---
toc: Configuring FS3
summary: Configuring FS3 chargen.
---
# Configuring FS3 - Chargen

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 Chargen Limits:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3skills_chargen.yml`

## Before You Start

You should read the article [Tweaking FS3](http://aresmush.com/fs3/fs3-3/tweaking-fs3/), which contains important information to help guide you in customizing your game.

## Free Skills

The first few points in Language and Background Skills are free, meaning they do not count toward a character's Ability Point total.  

* **free_languages**: Free points in Language Skills.  Make sure you assign 3 (Fluent) for each of the starting languages you set up in the skill list.
* **free_backgrounds**: Free points in Background Skills.

## Required Background Skills and Hooks

You can require how many Background Skills (distinct skills, not points) and RP hooks a character must start with.

* **min_backgrounds**: Minimum number of individual background skills.
* **min_hooks**: Minimum number of RP Hooks.

## Disallowed Ratings

FS3 Attributes are rated from 1-5 (with 5 being Exceptional) and Skills are rated from 1-8 (with 8 being Legendary).  Some games may not want to allow characters at the top end of the spectrum.  You can configure a hard limit on the ratings by setting **max\_skill\_rating** or **max\_attr\_rating** to the desired values.

## Rating Limits

You can configure various limits to what skills and attributes a character can have. 

> **Note:** These are soft limits.  The system will let someone go over them, but a warning will appear in their app command status.  You can choose whether to allow a special exception when approving the character.

* **max\_ap**: Total Ability Points (not counting free skills).
* **max\_attributes**: Total points in Attributes.
* **max\_skills\_above_4**: Number of distinct skills rated 5+.
* **max\_skills\_above_6**: Number of distinct skills rated 7+.
* **max\_attr\_above_3**: Number of distinct attributes rated 4+.
* **max\_attr\_above_4**: Number of distinct atributes rated 5.

## Starting Skills

FS3 lets you assign starting skills for different groups.  For example, you may want to ensure that people from a certain colony all start with a particular language, or that people in a certain position start with certain professional skills.

> **Note:** As with the rating limits, these are soft targets.  Nothing stops a character from lowering or removing these starting skills; they are just a starting point.  The app command status will have a warning if any starting skills are missing or too low.

Starting skills are group-based, so you'll see multiple entries for different groups in the list.  Here is an example:

    starting_skills:
        Faction:
            Navy:
                skills:
                    Swimming: 2
            Marines:
                skills:
                    Melee: 2
        Position:
            Pilot:
                skills:
                    Piloting: 3
            Rifleman:
                skills:
                    Firearms: 3
                    Melee: 3

A Navy Pilot would start with Swimming: 2 and Piloting: 3, whereas a Marine Pilot would start with Swimming: 2 and Piloting: 3.  The system will take the highest rating out of all applicable groups, so a Marine Rifleman would start with Melee: 3 and Firearms: 3.

### Group Notes

Sometimes you may want to prompt the player with a note about their skills.  You can do this with the optional 'notes' field.  For example, the following configuration will give a Combat Engineer Demolitions: 2 and prompt them to either raise it to 3 or add Technician at 3.

            Combat Engineer:
                notes: "A combat engineer should also take a 3 or higher in either Demo or Tech."
                skills:
                    Demolitions: 2
                    Firearms: 3

### Everyone Skills

All Action Skills start at the "Everyman" rating by default, which represents the basic skills all average people in the game world have.  You don't have to do anything special for this.

In some settings, you may want everyone to start better than average in some things.  To do this, use the special "Everyone" group.   For example, to make everyone start with Melee 2 (Amateur) in a military setting:

        Everyone:
            skills:
                Melee: 2