---
toc: FS3
summary: Managing and running combat scenes.
aliases:
- running
- organizer
- mod
- mods
- modifier
- combat_organizing
- combat_organize
- combat_organizer
- combat_running
- running_combat
- organizing_combat
- start_combat
- stop_combat
- combat_start
- combat_npc
- combat_mod
- combat_modifier
- combat_attackmod
- combat_defensemod
- combat_lethalmod
- combat_team
- combat_stop
- combat_newturn
- combat_log
- combat_target
---
# Organizing FS3 Combat

This is a quick reference for combat organizer commands. Also  check out the [Combat Organizer's Guide](/combat_org_guide).

## Running Combat
`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat.
`combats` - Shows all combats going on.
`combat/newturn` - Starts the first turn. Alias newturn.

`combat/join <list of names>=<combat #>[/<type>]` - Adds characters or NPCs to combats.
  Use `combat/types` to see available types and their associated gear.

## Combat Info
`combat/summary` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions.
`combat/idle <name>` - Sets someone as idle/not idle.  They won't be counted in pose tracking until you use the command on them again.
`combat/log <page>` - Views the combat log, with detailed messages about the rolls and effects.

## NPCs
You can always specify a NPC or player name in front of any action command to make them do something.  For example, `combat/join Bob/#123`.
Most commands support multiple names as well, so you can do: `combat/attack A B/C`.
**See [NPC](/help/npc) for more information on how spells, potions, and levels work for NPCs**

`combat/join <list of names>=<combat #>[/<type>]` - Creates temporary NPCs and adds them to the combat. 'Type' affects their available hitlocs. See `combat/types` for a list.
`combat/npc <name>=<level>` - Adjusts a NPC's skill level.  Level can be One, Two, Three, Four, Five, Six, Seven, Eight, Nine, or Ten. Levels Seven-Ten are Miniboss to Boss levels. See `combat/npcs` for more info.
`combat/targets` - See a breakdown of who's targeting whom.

`combat/team <list of names>=<team#>` - Switches teams.
`combat/target <team#>=<list of team #s>` - Sets it up so NPCs on a given team will only
    target people on the listed teams.  "combat/target 3=1 4" means team 3 will only target
    people on teams 1 and 4.

`combat/ai` - Auto-targets any NPCs who don't have actions yet.
`combat/ai force` - Auto-targets NPCs even if they have an action set.

## Damage, KOs, and death
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
`spell/mod <name>=<mod>` - Gives the combatant a modifier to their spell rolls.
`combat/clearmods <name>` - Clears all modifiers from combatant and sets to 0.
**Tip:** Mods set this way only last for one round.

##Specials
`combat/weaponspecials <name>=<special>[+<special>+<special>]` - Set a character or NPC's persistent weapon specials. Use 'None' to clear.

## Housekeeping
`combat/transfer <name>` - Transfer organizer powers to another person in combat.

`combat/scene <scene id>` - Ties combat to a scene, so combat messages will be included in the scene log.
    This will happen automatically as soon as someone poses.  The command exists in case you ever need to change it.
