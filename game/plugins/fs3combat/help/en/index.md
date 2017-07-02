---
toc: FS3 Combat
summary: Combat overview.
aliases:
- combat
---
# FS3 Combat

The FS3 Combat system is designed to bring some order to the chaos of large combat scenes, managing ability rolls and tracking damage in an automated fashion. For more help, see the [FS3 Combat Player's Guide](http://aresmush.com/fs3/fs3-3/combat).

`combat/start` or `combat/start mock` - Starts a combat. (Organizer only)
`combat/newturn` - Trigger a new turn. (Organizer only)

`combats` - Lists combats.
`combat/join <combat #>` - Joins a combat
`combat/join <combat #>/<type>` - Joins as a special type to auto-set weapons/armor.  See `combat/types`.
`combat/leave` - Leaves combat.

`combat` - View combat display

`combat/pilot <vehicle>` - Pilots a vehicle
       Use a vehicle type from `vehicles` to create a new vehicle, or a specific vehicle name if one already exists.
`combat/passenger <vehicle>` - Become a passenger in a vehicle.
`combat/disembark` - Leaves your vehicle.

`combat/weapon <weapon>[+<specials separated by +>]` - Set your weapon and any weapon specials.
        Use a weapon type of 'Unarmed' for no weapon.
`combat/armor <armor>` - Set your armor.
`combat/stance <stance>` - Set your stance (normal, aggressive, defensive, evade, hidden)

`combat/attack <target>` - Attack someone.
`combat/pass` - Pass this turn.

`combat/hero` - Spends a luck point to un-KO yourself.
`combat/luck <attack, defense or initiative>` - Spend a luck point this turn. 

**You can always specify a NPC or player name in front of any join or action command to make them do something.  For example, +combat/join Bob=#123.  You need the equals sign even if there are no command options.  For example, +combat/pass Bob=**

## Topics

[Actions](/help/fs3combat/actions)
[Damage](/help/fs3combat/damage)
[Gear](/help/fs3combat/gear)
[Organizing](/help/fs3combat/org)
[Luck](/help/fs3combat/luck)