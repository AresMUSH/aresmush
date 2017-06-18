---
toc: ~config~ Configuring FS3 Combat
summary: Configuring FS3 combat armor.
---
# Configuring FS3 Combat - Armor

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 armor types:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat_armor.yml`

## Before You Start

Read **[How Armor Works](http://aresmush.com/fs3/fs3-3/combat-mechanics#armor)** to understand how the armor mechanic works in FS3.

## Armor Types

You can define as many kinds of armor as you want.  FS3 armor types have the following stats:

### Description

The description is just ree-form text describing the armor.  It's best to use double quotes around it.

### Protection Values

You can specify different protection values for different locations, making weak spots or skipping areas that are completely uncovered. For example, a simple kevlar vest might protect the chest and abdomen but nowhere else:

        Police:
            protection: 
                Chest: 6 
                Abdomen: 5

Armor is a simple opposed roll between the armor's protection value and the weapon's penetration value.  The armor may reduce or even stop the attack.  

> **Tip:** It takes a solid victory (2 net successes) for armor to cleanly stop an attack, so you want to make sure your armor has at least some chance of getting that many successes.  An armor value of 3 would hardly stop anything.

## Mixing Armor

A character can only wear one kind of armor at a time; you can't mix and match.  If armor has different configurations, you'll need to set them up as separate armor types.  For example, you might have armor types for both "Tactical Vest" (for just the vest) and "Tactical Full" (for vest + helmet).

## Vehicle Armor

Vehicles can have armor.  It works the same way as personal armor, but it is automatically 'worn' by the vehicle; you don't have to use a separate command to apply it.