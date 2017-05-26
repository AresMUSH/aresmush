---
toc: Configuring FS3 Combat
summary: Configuring miscellaneous FS3 Combat options.
---
# Configuring FS3 Combat - Miscellaneous

> **Permission Required:** Configuring the game requires the Admin role.

This topic describes some miscellaneous combat options you can configure.

## Lethality Tuning

To tune how lethal combat is overall:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat.yml` 

There are two settings you can adjust:

1. `pc_knockout_bonus` - Number of dice added to PC knockout rolls.
2. `npc_lethality_mod` - A modifier added to all NPC damage to make it more lethal.

By default, these values are skewed so that PCs are harder to knock out and NPCs take more damage overall.

## NPCs

To configure FS3's NPC statistics:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat_npcs.yml`

FS3 has three NPC types: Goon, Henchman and Boss.  The simplest configuration is just to assign each of them a die rating:

    npc_types:
        Goon:
            Default: 4
        Henchman:
            Default: 6
        Boss:
            Default: 8

However, you can also fine-tune their specific skills.  This is helpful if you want to make a Boss tough to take down without making them extraordinarily deadly (or vice-versa).

    npc_types:
        Goon:
            Default: 4
            Firearms: 6
            Gunnery: 6
            Piloting: 4
        Henchman:
            Default: 6
            Firearms: 8
            Gunnery: 8

Any skills not expressly listed will use the 'Default' value.

## Combatant Types

To configure FS3's combatant types:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat.yml`

The system lets you specify different combatant types.  One of these is "Observer", which cannot be changed.  The rest can be configured as you desire.

You can configure which weapon, weapon specials and armor that combatant type starts with.  All of these are optional, and can be omitted if they don't apply.  

You must also specify the hit location table.  

> **Note:** Hit location and armor are for the pilot, not the vehicle.  Vehicles automatically have their own hit location table and armor value.

For example, this BSG config sets up a Soldier type for ground marines and a Viper type for a viper pilot.  The soldier starts with a rifle and armor, and the pilot starts off piloting a Viper.

        Soldier:
            weapon: Rifle
            weapon_specials: 
                - Ap
            armor: Tactical
            hitloc: Humanoid
            defense_skill: Reflexes
        Viper:
            vehicle: Viper
            hitloc: Humanoid
            defense_skill: Piloting

## Default Combatant Type

You need to specify which of your combatant types is the default if the player doesn't specify a value.