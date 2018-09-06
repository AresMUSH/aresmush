---
toc: FS3 Combat
summary: Participating in combat scenes.
aliases:
- combat
- vehicles
- weapons
- weapon
- vehicle
order: 1
---
# FS3 Combat

The FS3 Combat system is designed to bring some order to the chaos of large combat scenes, managing ability rolls and tracking damage in an automated fashion. 

To learn how FS3 combat works, you should read the [FS3 Combat Player's Guide](http://aresmush.com/fs3/fs3-3/combat) and try out the [Interacive Combat Walkthrough](http://aresmush.com/fs3/fs3-3/combat-walkthrough).

There is also an online [Quick Reference](http://aresmush.com/fs3/fs3-3/combat-quickref) to the most common combat commands.

## Actions

> **Tip:** You can always specify a NPC or player name in front of any action command to make them do something.  For example, combat/join Bob=#123.  You need the equals sign even if there are no command options.  For example, combat/pass Bob=
>
> Most commands support multiple names as well, so you can do: combat/attack A B=C

`combat/stance <stance>` - Sets stance for your actions.

`combat/attack <target>[/<specials, see below>]`

    Specials are optional. Use commas to separate multiple options.
    * burst - Fire a short (3-round) burst. 
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location. 
       Use `combat/hitlocs <target>` to see a list of valid hit locations. 
    * crew - Attack a vehicle crewperson directly instead of the vehicle itself.
    * mount - Attack a mount directly instead of the rider.

`combat/aim <target>` - Takes careful aim.

`combat/reload` – Reloads a weapon.

`combat/treat <name>` - Treat an injured person's worst treatable wound.

`combat/rally <name>` - Rally a knocked out person (without first aid).

`combat/pass` - Take no action this turn.

`combat/fullauto <list of targets>` - Fire a full-auto burst

`combat/explode <list of targets>` - Use an explosive weapon.

`combat/suppress <target>` - Use suppressive fire
    A full-auto or explosive weapon can specify a list of up to 3 targets.

`combat/distract <target>` - Distracts a target

`combat/subdue <target>` - Subdues or disarms a target. 
`combat/escape` – Attempts to escape while subdued.

`combat/randtarget <number of targets>` - Suggests a couple potential targets at random.

## Gear

There are various kinds of gear that can be used in combat.  You should only use gear that is appropriate to the IC situation.  Just because the code will let you pick a rocket launcher doesn't mean you have a rocket launcher.  RP appropriately.

`weapons` - List all weapons.
`weapon <name>` - See details for a particular weapon.
`combat/weapon <name+specials>` - Sets your weapon.

`armor` - List all types of armor.
`armor <name>` - See details for a particular armor type.
`combat/armor <name+specials>` - Sets your armor.

## Vehicles and Mounts

On some games, you can use vehicles or mounts in combat.

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

Each turn, you can spend a [Luck Point](/help/luck) to get +3 bonus dice to either attack, defense or initiative.  You can only spend luck on one of them per turn, so make sure it's something relevant to what you're going to do that turn.

`combat/luck <attack, defense or initiative>` - Spend a luck point this turn. 

You can also spend a luck to avoid a knockout.  This doesn't erase the damage, it just lets you soldier on in spite of it.

`combat/hero` - Spends a luck point to un-KO yourself.

> **Tip:** Before spending luck, remember that in some situations another play may be able to revive you with a rally or treat.  You might want to give them a chance first and save your luck for a more dire situation.