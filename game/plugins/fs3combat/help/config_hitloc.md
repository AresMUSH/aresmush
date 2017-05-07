---
toc: Configuring FS3 Combat
summary: Configuring FS3 combat damage.
---
# Configuring FS3 Combat - Hit Locations

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 hit location tables:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat_hitloc.yml`

## Before You Start

FS3 uses a somewhat unique hit location system.  See **[How Hit Location Works](http://aresmush.com/fs3/fs3-3/combat-mechanics#hit-location)** for more info on how it works.

## Hit Location Types

FS3 lets you define different hit location tables for different combatant types.  Usually you'll have one for humanoids and one for each distinct kind of vehicle, but you can do more than that.  Maybe your game needs one for "alien quadraped" or "horse" too.

Each hit location type has several properties, described below.

### Areas

The 'areas' configuration lists all possible hit locations on the target.  The **first location** is considered the default hit location, assuming the person is aiming at the target's "center of mass". This would be the chest on a human or the body of an aircraft, for example.

When you aim at a location but don't roll well enough to hit it outright, there's a chance you might hit somewhere nearby.  Each hit location has a list of nearby locations.  For example:

    Humanoid:
        areas:
            Chest: [ 'Left Leg', 'Right Leg',  'Left Arm', 'Right Arm', 'Abdomen', 'Abdomen', 'Head', 'Chest', 'Chest', 'Chest' ]
            Left Leg: [ 'Chest', 'Right Foot', 'Right Leg', 'Right Leg', 'Abdomen', 'Abdomen', 'Left Foot', 'Left Leg', 'Left Leg', 'Left Leg' ]

If you aim at the chest, you could hit an arm, a leg, the abdomen, the head, or you might get lucky and still hit the chest.   If you aim for the left leg, you don't have a chance of hitting the head, but you might hit the foot.

Each location should have **ten** entries.  You can list an entry more than once to make it more likely to come up.   For example: in the Chest hit location above, there's a 10% chance of hitting the Right Leg (1 entry) but a 20% chance of hitting the abdomen (2 entries).

Hit location is shifted to the right based on the success of the to-hit roll, so entries closest to the desired hit location should be at the **end** of the list.

### Vital and Critical Areas

For each hit location type, you can list "Vital" and "Critical" areas.  All other areas not listed are considered "Non-Vital".  

Vital areas have no damage modifier.  Critical areas have +30% and Non-Vital areas have a -10%.

    Humanoid:
        vital_areas:
            - Chest
            - Abdomen
        critical_areas:
            - Head
            - Neck

###  Crew Areas

For a vehicle, you need to specify which hit locations have crew/passengers in them.  A hit to this location has a chance of injuring the people inside.

    Transport:
        crew_areas:
            - Cockpit