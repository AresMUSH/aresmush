---
toc: FS3
summary: Managing and running combat scenes.
aliases:
- running
- organizer
- mod
- mods
- modifier
- combat/start
- combat/stop
- combat_organizing
- combat_organize
- combat_organizer
- combat_running
- running_combat
- organizing_combat
- start_combat
- stop_combat
---
# Organizing FS3 Combat

This is a quick reference for combat organizer commands. Also  check out the [Running Combats](http://aresmush.com/fs3/fs3-3/running-combat) tutorial.

## Running Combat
`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat.
`combats` - Shows all combats going on.
`combat/newturn` - Starts the first turn.

`combat/join <list of names>=<combat #>[/<type>]` - Adds characters or NPCs to combats.
  Use `combat/types` to see available types and their associated gear.

## Combat Info
`combat/summary` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions.
`combat/idle <name>` - Sets someone as idle/not idle.  They won't be counted in pose tracking until you use the command on them again.
`combat/log <page>` - Views the combat log, with detailed messages about the rolls and effects.

## NPCs
You can always specify a NPC or player name in front of any action command to make them do something.  For example, combat/join Bob/#123.
Most commands support multiple names as well, so you can do: combat/attack A B/C.
**See [NPC](/help/npc) for more information on how spells, potions, and levels work for NPCs**

`combat/join <list of names>=<combat #>[/<type>]` - Creates temporary NPCs and adds them to the combat. 'Type' affects their available hitlocs. See `combat/types` for a list.
`combat/npc <name>=<level>` - Adjusts a NPC's skill level.  Level can be One, Two, Three, Four, Five, Six, Seven, Eight, Nine, or Ten. Levels Seven-Ten are Miniboss to Boss levels.
`combat/targets` - See a breakdown of who's targeting whom.

`combat/team <list of names>=<team#>` - Switches teams.
`combat/target <team#>=<list of team #s>` - Sets it up so NPCs on a given team will only
    target people on the listed teams.  "combat/target 3=1 4" means team 3 will only target
    people on teams 1 and 4.

`combat/ai` - Auto-targets any NPCs who don't have actions yet.
`combat/ai force` - Auto-targets NPCs even if they have an action set.

## Damage and KOs
Admins, combat organizers, and characters with the manage_combat permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<initial severity>/<current severity>/<IC date>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.

`combat/unko` - Un-KO's someone who shouldn't have been.
`death/undo` - Admin-only command to raise someone from the dead.

## Mods
`combat/attackmod <name>=<modifier>` - Gives the combatant a modifier to attack
`combat/defensemod <name>=<modifier>` - Gives the combatant a modifier to defend
`combat/lethalmod <name>=<modifier>` - Gives the combatant a modifier to lethality on damage TAKEN
`spell/hascast <name>=<true/false>` - Changes a character or NPC's 'has cast' value so that they can cast again if they spend luck.
`spell/mod <name>=<mod>` - Gives the combatant a modifier to their spell rolls.
**Tip:** Mods only last for one round.


## Housekeeping
`combat/transfer <name>` - Transfer organizer powers to another person in combat.

`combat/scene <scene id>` - Ties combat to a scene, so combat messages will be included in the scene log.
    This will happen automatically as soon as someone poses.  The command exists in case you ever need to change it.
