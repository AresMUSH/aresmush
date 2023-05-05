---
<<<<<<< HEAD
toc: 5 - Magic, FS3 Skills, and Combat
=======
toc: FS3 Skills and Combat
>>>>>>> upstream/master
summary: Participating in combat scenes.
aliases:
- vehicles
- weapons
- weapon
- vehicle
- gear
<<<<<<< HEAD
=======
- mount
>>>>>>> upstream/master
---
# FS3 Combat

The FS3 Combat system is designed to bring some order to the chaos of large combat scenes.

> Learn how the combat system works in the [Combat Tutorial](/help/fs3combat_tutorial).

## Actions

> **Tip:** You can always specify a NPC or player name in front of any action command to make them do something.  For example, combat/join Bob=#123.  You need the equals sign even if there are no command options.  For example, combat/pass Bob=
>
> Most commands support multiple names as well, so you can do: combat/attack A B=C
>
>You can target mythics as well as

`combat/stance <stance>` - Sets stance for your actions.  You can use `combat/stances` to see a list of possible stances.

`combat/mount <mythic>` - Mounts your mythic in combat. Attacks directed at one have a chance to hit the other.

`combat/attack <target>[>mod:<mod>] OR [>called:<hitloc>]`

    These are optional. Use commas to separate multiple options.
    * mod:<special modifiers> - Dice to add or subtract to the roll.
<<<<<<< HEAD
    * called:<location> - Perform a called shot to a particular hit location.
       Use `combat/hitlocs <target>` to see a list of valid hit locations.

`combat/spell <spell>[/<target> <target>]` - Cast a spell in combat. Spells with no target will cast on the environment or the caster.

`combat/potion <potion>[/<target>]` - Use a potion in combat.
=======
    * called:<location> - Perform a called shot to a particular hit location. 
       Use `combat/hitlocs <target>` to see a list of valid hit locations. 
    * crew - Attack a vehicle crewperson directly instead of the vehicle itself.
    * mount - Attack a mount directly instead of the rider.
>>>>>>> upstream/master

`combat/aim <target>` - Takes careful aim.

`combat/reload` – Reloads a weapon.

`combat/treat <name>` - Treat an injured person's worst treatable wound.

`combat/rally <name>` - Rally a knocked out person (without first aid).

`combat/pass` - Take no action this turn.

`combat/explode <list of targets>` - Use an explosive weapon.

`combat/distract <target>` - Distracts a target

`combat/subdue <target>` - Subdues or disarms a target.
`combat/escape` – Attempts to escape while subdued.

`combat/randtarget <number of targets>` - Suggests a couple potential targets at random.

## Gear

<<<<<<< HEAD
> **Note:** There are various kinds of gear that can be used in combat. You should only use gear that is appropriate to the IC situation.
=======
> **Note:** FS3 Combat has no inventory system, so you should only use gear that is appropriate to the IC situation.  Just because the code will let you pick a rocket launcher doesn't mean you have a rocket launcher.  RP appropriately.
>>>>>>> upstream/master

`weapons` - List all weapons.
`weapon <name>` - See details for a particular weapon.
`combat/weapon <name+specials>` - Sets your weapon.

`armor` - List all types of armor.
`armor <name>` - See details for a particular armor type.
`combat/armor <name+specials>` - Sets your armor.
<<<<<<< HEAD

## Luck

`combat/luck <spell, attack, defense or initiative>` - Spend a luck point this turn.
=======

## Vehicles and Mounts

> **Note:** Vehicles and mounts may not be supported on all games.

`vehicles` - List all types of vehicles.
`vehicle <name>` - See details for a particular vehicle type.
`combat/pilot <vehicle type or name>` - Pilots a vehicle.
`combat/passenger <vehicle type or name>` - Becomes a passenger in a vehicle.
        You can also use a person's name to join them in a vehicle.
`combat/disembark` - Leaves a vehicle.

`mounts` - Lists all types of mounts.
`mount <name>` - See details for a particular mount type.
`combat/mount <name>` - Mounts an animal.
`combat/dismount` - Dismounts an animal.

## Luck

`combat/luck <attack, defense or initiative>` - Spend a luck point this turn. 
>>>>>>> upstream/master
`combat/hero` - Spends a luck point to un-KO yourself.

## Organizing

See [Organizing Combat](/help/combat_org)