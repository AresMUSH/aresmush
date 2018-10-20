---
toc: FS3 Combat
summary: Participating in combat scenes.
aliases:
- vehicles
- weapons
- weapon
- vehicle
- gear
- mount
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

`combat/pass` - Take no action this turn.

`combat/stance <stance>` - Sets stance for your actions.  You can use `combat/stances` to see a list of possible stances.

`combat/attack <target>[>mod:<mod>] OR [>called:<hitloc>]`
    Specials are optional. Use commas to separate multiple options.
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location.
       Use `combat/hitlocs <target>` to see a list of valid hit locations.


`combat/explode <list of targets>` - Use an explosive weapon.

`spell/cast <spell>` - Casts a spell that doesn't need a target.
`spell/cast <spell>=<target>` - Casts a spell that needs a target.
`potion/use <potion>` - Uses a potion.

`combat/distract <target>` - Distracts a target
`combat/subdue <target>` - Subdues or disarms a target.
`combat/escape` – Attempts to escape while subdued.
`combat/aim <target>` - Takes careful aim.

`combat/treat <name>` - Treat an injured person's worst treatable wound. (requires medicine)
`combat/rally <name>` - Rally a knocked out person (without first aid). (requires medicine)

## Gear
There are various kinds of gear that can be used in combat.  You should only use gear that is appropriate to the IC situation.

`weapons` - List all weapons.
`weapon <name>` - See details for a particular weapon.
`combat/weapon <name+specials>` - Sets your weapon.

`armor` - List all types of armor.
`armor <name>` - See details for a particular armor type.
`combat/armor <name+specials>` - Sets your armor.

## Luck

Luck points (see [Luck](/help/luck)) have special effects in combat.

### Bonus Dice

`combat/luck <attack, defense or initiative>` - Spend a luck point to get +3 bonus dice this turn.

> **Tip:** Spending luck on attack affects special attacks like explosions or suppression.  It also conveys a bonus to damage.

### Avoiding Knockout
`combat/hero` - Spends a luck point to un-KO yourself. This doesn't erase the damage, it just lets you soldier on in spite of it.

## Damage
`damage` - Views your damage.
`damage <name>` - Views someone else's damage.

The healing progress bar on the damage display shows how close you are to reducing the wound by one level.

## Treating
For first aid/treatment immediately after an injury, medics can use the treat command.  Each treatment affects only a single wound. Requires Medicine.
`combat/treat <name>` - In combat, treats someone's wounds with immediate first aid.
`treat <name>` - Treats someone's wounds with immediate first aid.

## Healing
For more longer-term healing, doctors can use the heal command.  You will continue healing someone until they are well. Requires Medicine.

`heal/start <name>` - Takes someone as a patient.
`heal/stop <name>` - Removes a patient.
`heal/list` - Shows your patients.
`heal/scan` - Find injured patients who might need your services.

## Hospitals
When a room is marked as a hospital, people who are there heal faster.

`hospitals` - Finds hospitals.
`hospital/on` or `hospital/off`- Toggles whether the current room is a hospital.

## Adjusting Damage
Admins, combat organizers, and characters with the manage_combat permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<initial severity>/<current severity>/<IC date>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.

## Organizing

This is a quick reference for combat organizer commands.   You may also want to check out the [Running Combats](http://aresmush.com/fs3/fs3-3/running-combat) tutorial on AresMUSH.com.

`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat.
`combats` - Shows all combats going on.
`combat/newturn` - Starts the first turn.

`combat/join <list of names>=<combat #>[/<type>]` - Adds characters or NPCs to combats.
  Use `combat/types` to see available types and their associated gear.

`combat/summary` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions.
`combat/idle <name>` - Sets someone as idle/not idle.  They won't be counted in pose tracking until you use the command on them again.

`combat/npc <name>=<level>` - Adjusts a NPC's skill level.  Level can be Goon, Henchman, Miniboss, Boss
`combat/targets` - See a breakdown of who's targeting whom.

`combat/team <list of names>=<team#>` - Switches teams.
`combat/target <team#>=<list of team #s>` - Sets it up so NPCs on a given team will only
    target people on the listed teams.  "combat/target 3=1 4" means team 3 will only target
    people on teams 1 and 4.

`combat/ai` - Auto-targets any NPCs who don't have actions yet.
`combat/ai force` - Auto-targets NPCs even if they have an action set.

`combat/unko` - Un-KO's someone who shouldn't have been

`combat/attackmod <name>=<modifier>` - Gives the combatant a modifier to attack
`combat/defensemod <name>=<modifier>` - Gives the combatant a modifier to defend
`combat/lethalmod <name>=<modifier>` - Gives the combatant a modifier to lethality on damage TAKEN

`combat/transfer <name>` - Transfer organizer powers to another person in combat.

`combat/scene <scene id>` - Ties combat to a scene, so combat messages will be included in the scene log.  
    This will happen automatically as soon as someone poses.  The command exists in case you ever need to change it.

`combat/log <page>` - Views the combat log, with detailed messages about the rolls and effects.

=======
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

You can spend luck to get a bonus on attack, defense or initiative, or undo a knockout.

`combat/luck <attack, defense or initiative>` - Spend a luck point this turn. 
`combat/hero` - Spends a luck point to un-KO yourself.

## Organizing

See [Organizing Combat](/help/combat_org)
