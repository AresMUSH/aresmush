---
toc: FS3 Combat
summary: Organizing combat scenes.
---
# FS3 Combat - Organizing

This is a quick reference for combat organizer commands.   You may also want to check out the [Running Combats](http://aresmush.com/fs3/fs3-3/running-combat) tutorial on AresMUSH.com.


`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat. 
`combats` - Shows all combats going on. 
`combat/newturn` - Starts the first turn.

`combat/join <list of names>=<combat #>[/<type>]` - Adds people to combats.
  Use `combat/types` to see available types and their associated gear.

`combat/summary` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions.

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