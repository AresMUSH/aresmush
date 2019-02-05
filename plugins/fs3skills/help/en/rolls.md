---
toc: Using FS3
summary: Making ability rolls.
order: 3
aliases:
- opposed
- roll
- rolls
---
# FS3 - Ability Rolls

This game uses the FS3 skills system.  This is a quick reference for the commands used to make an ability roll.  For more help, see the [FS3 Player's Guide](http://aresmush.com/fs3/fs3-3).

`roll <ability>`
`roll <character>/<ability>` - Makes a roll for someone else.
`roll/private <ability>` - Shows results only to yourself.
`roll <character>/<ability> vs <character>/<ability>` - Makes an opposed roll.

Except for private rolls, all rolls may be emitted to a special roll results channel so admins and storytellers not in the room can see results.

## Types of Rolls

Typically you will roll a skill.  (e.g. roll Firearms)

The attribute dice are automatically added in based on the ability's configured related attribute.   For action skills, this is shown on your sheet.

You can specify a different attribute when the default one doesn't make sense (e.g. roll Firearms+Mind for a knowledge-based challenge), or for background skills/languages/advantages, which all default to Wits (e.g. roll Acting+Presence).

## Defaulting

You may roll an attribute by itself if you are defaulting to the "Everyman" ability for common knowledge (e.g. roll Wits will roll Wits + 1 die for the Everyman ability)

## Modifiers

You can apply a + or - modifier.  The modifier increases or decreases your ability rating, adding or subtracting dice.  (e.g. roll Firearms-1)

## Rolling for NPCs

For NPCs, you can specify a skill rating (e.g. roll 4).  Note that the code automatically factors in an average attribute.