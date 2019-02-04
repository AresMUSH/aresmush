---
toc: Using FS3
summary: Choosing your character's skills.
order: 2
aliases:
- reset
- language
- languages
- raise
- lower
- ability
- attribute
- attributes
- specialty
- specialties
- advantages
- abilities
---
# FS3 Skills

This game uses the FS3 skills system, Third Edition.  The complete rulebook can be found online: [FS3 Player's Guide](http://www.aresmush.com/fs3/fs3-3).

## Resetting Skills

To get started, or at any point you wish to reset yourself, use the reset command.

`reset` - Resets your abilities, setting default values based on your groups.
         **This will erase any abilities you have, so do this first!**

## Viewing Your Sheet

At any time you can check your current status and progress using the `sheet` and `app` commands.

## Raising Abilities

Use the Abilities command to see the ratings, available abilities and descriptions.

`abilities` - Lists abilities.

There are two ways to adjust your abilities.  All abilities use the same commands:   

`raise <name>` and `lower <name>` - Raise or lower by 1 level.
`ability <name>=<level>` - Sets the rating

## Adding Specialties

Some abilities require specialization.  You can add or remove a specialty:

`specialty/add <ability>=<specialty>` or `specialty/remove <ability>=<specialty>`

## Adding RP Hooks

See [Hooks](/help/hooks).


## Finding Other People With Skills

If you're looking for a character with a specific skill, you can use the skill scan command.  It will list anyone with that skill above Everyman (or above Average for attributes).  People in your room are highlighted.

`skill/scan <name>`