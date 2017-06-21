---
toc: ~config~ Configuring FS3 Combat
summary: Configuring FS3 combatant types.
---
# Configuring FS3 Combat - Combatant Types

> **Permission Required:** Configuring the game requires the Admin role.

Combatant types in FS3 let you specify different kinds of soldiers, pilots, aliens, etc.  Each combatant type can have a different weapon, skills and armor.  

To configure the combatant types:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat.yml`

One combatant type is "Observer", which cannot be changed.  The rest can be configured as you desire.  

You **must** specify the defense skill (used against ranged combat) and hit location table (from [Hit Location Config](/help/fs3combat/config/hitloc)).  You may also specify weapon, weapon specials and armor.

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

You need to specify which of your combatant types is the default if the player doesn't specify a value.  Just set the `default_type` value to one of the combatant types (e.g. Soldier).