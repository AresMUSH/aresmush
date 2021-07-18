---
toc: FS3 Skills and Combat
order: 1
tutorial: true
summary: Skills and Combat System
---
# FS3

This game uses the FS3 system, Third Edition.  The complete guide can be found online: [FS3 Player's Guide](http://www.aresmush.com/fs3/fs3-3).

![Sheet Page Screenshot](https://aresmush.com/images/help-images/sheet.png)

[[toc]]

## Abilities

FS3 has several basic types of abilities:

* **Attributes** represent basic abilities that everyone has to some extent. Attributes boost related skills, and come into play when no skill directly applies. Attributes are rated from 1-4. 
* **Action Skills** represent your ability in areas deemed important for gameplay. Action Skills are rated from 0-8. 
* **Background Skills** represent arts, sports, hobbies, professions and any other skills your character possesses that are not already covered by Action Skills.  Background Skills are rated from 1-3. Background Skills are free-form, so there is no set list. 
* **Languages** represent your ability to speak and read other languages. Languages are rated from 1-3. 
* Some games also have **Advantages**, which are rated like background skills but are not skills.  

For a list of specific abilities available on your game, you can use the `abilities` command or the web portal abilities page (usually under System -> Abilities List).

> **Tip:** See the [Chargen](https://aresmush.com/fs3/fs3-3/chargen.html) section of the player's guide for details about the ratings, costs, and how to choose abilities.

## Sheets

You can view your character sheet on the 'Sheet' tab of your web portal profile or the `sheet` command.  If your game permits it, you can also look at other character sheets in the same way.  This information is provided for OOC reference; do not use it inappropriately if you have no IC reason to know it.

## Rolls

An Ability Roll is used when you want to know if you succeed or fail at a given task using one of your Abilities. You roll (virtual) dice based on how good you are, and the result determines the outcome.

> **Tip:** See the [Conflict](https://aresmush.com/fs3/fs3-3/conflict.html) section of the player's guide for details about when and how to use ability rolls to resolve conflicts.

The basic roll mechanic in FS3 is to roll a number of dice equal to Attribute + Ability, and count successes.  One success is enough to accomplish the task at hand; more successes mean you do better than expected.

    <FS3> Hannah rolls Firearms: Good Success (7 7 7 4)

You can also do opposed rolls, which basically just compare the number of successes from each side and figure out who won and by how much.

    <FS3> Flare rolls Firearms (8 4 3 2 1) vs Ivan's Firearms (8 7 6 6 6 5 5 2 1 1)
    <FS3>          Crushing Victory for Ivan.

When rolling an ability, the system will assume you want to use the default linked attribute. You can also specify which attribute to use, or roll _just_ an attribute (this is used when "defaulting" to a skill you don't have, and assumes an Everyman level):

    roll Firearms         Rolls Firearms + the linked attribute (shown on your sheet)
    roll Firearms+Wits    Rolls Firearms with an explicit linked attribute
    roll Wits             Rolls Wits with an assumed skill of "Everyman" (defaulting)

You can add modifiers to any of the above, which just add dice.

    roll Firearms+2
    roll Firearms+Wits-1

And finally, for NPCs you can just roll a skill rating.  An attribute of 2 is factored in automatically.

    roll 3                Rolls 5 dice total (Competent skill + Average attribute)

## Luck

Luck Points in FS3 can be used to generate various lucky breaks.  Luck points are earned by participating in scenes. You can use luck points for combat, ability rolls, or other plot points at the storyteller's discretion.

> **Tip:** See the [Luck](https://aresmush.com/fs3/fs3-3/luck.html) section of the player's guide for details about when and how to use luck points.

Luck is awarded for participation in scenes.  You get a fraction of a luck point for each participant.  There are bonuses for RPing with someone for the first time, and for RPing with a new player.  There are diminishing returns if you always RP with the same people.  Admins can also issue luck as rewards.

You can see your available luck points on your character sheet.

## Experience Points

Experience Points (XP) are gained periodically to reflect what your character has been learning and/or practicing during that time.  You spend them to improve your abilities.  

> **Tip:** See the [Experience](https://aresmush.com/fs3/fs3-3/experience.html) section of the player's guide for details about how to use experience points.

Each XP you spend toward a skill progresses you further towards the next rating.  There is a cooldown between XP spends of the same ability, and a limit on the amount of XP you can store up.  This means you must learn skills incrementally over time, and not expect to bank a ton of XP and jump ratings all at once.

You can see your progression in all abilities on the "Experience" tab of your web portal character profile, or the `xp` command.

## Finding Other People With Skills

If you're looking for a character with a specific skill, you can use the `skill/scan` command (if the game has enabled visible sheets).  It will list anyone with that skill above Everyman (or above Average for attributes).  People in your room are highlighted.  You can also see a summary of people within the different skill categories.

## Command Reference

[Skills](/help/skills)
[Character Sheet](/help/sheet)
[Ability Rolls](/help/rolls)
[Luck](/help/luck)
[Experience](/help/xp)
[Combat](/help/combat) (if your game has enabled the combat system)

## Copyright

The FS3 System Copyright 2007 by Faraday and is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-nc-sa/4.0/).