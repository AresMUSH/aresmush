---
toc: FS3
summary: Managing combat scenes.
aliases:
- combat
- vehicles
- weapons
- weapon
- vehicle
- treat
- heal
- healing
- hospitals
- damage
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

## Damage

`damage` - Views your damage. 
`damage <name>` - Views someone else's damage.

Note that the healing progress bar on the damage display just shows how close you are to reducing the wound by one level. 

## Treating

For first aid/treatment immediately after an injury, medics can use the treat command.  Each treatment affects only a single wound.  Inside combat, you use `combat/treat <name>` instead.

`treat <name>` - Treats someone's wounds with immediate first aid.

## Healing

For more longer-term healing, doctors/healers can use the heal command.  You will continue healing someone until they are well.  

`heal/start <name>` - Takes someone as a patient.
`heal/stop <name>` - Removes a patient.
`heal/list` - Shows your patients.
`heal/scan` - Find injured patients who might need your services.

## Hospitals

When a room is marked as a hospital, people who are there heal faster.  

`hospitals` - Finds hospitals.

Admins or builders with the `setup_hospitals` permission can designate rooms as hospitals.

`hospital/on` or `hospital/off`- Makes the current room a hospital or not.

## Adjusting Damage

Admins, combat organizers, and characters with the manage_damage permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<severity>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.

## Gear

There are various kinds of gear that can be used in combat.  You should only use gear that is appropriate to the IC situation.  Just because the code will let you pick a rocket launcher doesn't mean you have a rocket launcher.  RP appropriately.

`weapons` - List all weapons.
`weapon <name>` - See details for a particular weapon.

`armor` - List all types of armor.
`armor <name>` - See details for a particular armor type.

`vehicles` - List all types of vehicles.
`vehicle <name>` - See details for a particular vehicle type.

## Luck

Luck points (see [Luck](/help/luck)) have special effects in combat.

### Bonus Dice

Each turn, you can spend a luck point to get +3 bonus dice to either attack, defense or initiative.  You can only spend luck on one of them per turn, so make sure it's something relevant to what you're going to do that turn.

`combat/luck <attack, defense or initiative>` - Spend a luck point this turn. 

> **Tip:** Spending luck on attack affects special attacks like explosions or suppression.  It also conveys a bonus to damage.

### Avoiding Knockout

You can also spend luck to avoid a knockout.  This doesn't erase the damage, it just lets you soldier on in spite of it.

`combat/hero` - Spends a luck point to un-KO yourself.

> **Tip:** Before spending luck, remember that in some situations another play may be able to revive you with a rally or treat.  You might want to give them a chance first and save your luck for a more dire situation.

## Organizing

This is a quick reference for combat organizer commands.   You may also want to check out the [Running Combats](http://aresmush.com/fs3/fs3-3/running-combat) tutorial on AresMUSH.com.

`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat. 
`combats` - Shows all combats going on. 
`combat/newturn` - Starts the first turn.

`combat/join <list of names>=<combat #>[/<type>]` - Adds people to combats.
  Use `combat/types` to see available types and their associated gear.

`combat/summary` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions.
`combat/idle <name>` - Sets someone as idle/not idle.  They won't be counted in pose tracking until you use the command on them again.

`combat/npc <name>=<level>` - Adjusts a NPC's skill level.  Level can be Goon, Henchman, Boss

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

