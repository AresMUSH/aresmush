---
toc: FS3 Skills and Combat
summary: Managing combat scenes.
aliases:
- combat_organizer
- combat_organizing
- combat_start
- combat_npc
- combat_mod
- combat_modifier
- combat_attackmod
- combat_defensemod
- combat_lethalmod
- combat_initmod
- combat_team
- combat_stop
- combat_newturn
- combat_log
- combat_target
- combat_ai
---

# Organizing Combat

This is a quick reference for combat organizer commands.  

> Learn how the combat system works in the [Combat Tutorial](/help/fs3combat_tutorial).

`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat. 
`combats` - Shows all combats going on. 
`combat/newturn` - Starts the first turn.

`combat/join <list of names>=<combat #>[/<type>]` - Adds people to combats.
  Use `combat/types` to see available types and their associated gear.

`combat/summary [<name>]` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions. Specifying a name will match only combatants whose names start with the given text.
`combat/idle <name>` - Sets someone as idle/not idle.  They won't be counted in pose tracking until you use the command on them again.

`combat/npc <name>=<level>` - Adjusts a NPC's skill level.  See `combat/npcs` for a list of options.
`combat/vehicles` - See a breakdown of who's in what vehicles.

`combat/unko` - Un-KO's someone who shouldn't have been

`combat/attackmod <name>=<modifier>` - Gives the combatant a modifier to attack.
`combat/defensemod <name>=<modifier>` - Gives the combatant a modifier to defend.
`combat/lethalmod <name>=<modifier>` - Gives the combatant a modifier to lethality on damage TAKEN.
`combat/initmod <name>=<modifier>` - Gives the combatant a modifier to initiative.
`combat/ammo <name>=<ammo>` - Adjusts remaining ammo.

`combat/transfer <name>` - Transfer organizer powers to another person in combat.

`combat/scene <scene id>` - Ties combat to a scene, so combat messages will be included in the scene log.  
    This will happen automatically as soon as someone poses.  The command exists in case you ever need to change it.

`combat/log <page>` - Views the combat log, with detailed messages about the rolls and effects.


## Targeting

`combat/targets` - See a breakdown of who's targeting whom.

`combat/team <list of names>=<team#>` - Switches teams. 
`combat/target <team#>=<list of team #s>` - Sets it up so NPCs on a given team will only 
    target people on the listed teams.  "combat/target 3=1 4" means team 3 will only target 
    people on teams 1 and 4.

`combat/ai` - Selects actions/targets for any NPCs who don't have actions yet.
`combat/ai force` - Selects new actions/targets ALL NPCs, even if they have an action set.
`combat/ai <list>` - Selects actions/targets for the list of NPCs.   You can specify a target for any or all
    NPcs by doing "npc:target".  For example:  combat/ai Bob:Tom Harry:Sally Mick  will have Bob
    target Tom, Harry target Sally, and Mick pick a random target.
