---
topic: combat org
toc: FS3 Combat
summary: Commands for combat organizers.
categories:
- main
- admin
plugin: fs3combat
---
This is a quick reference for combat organizer commands.  For more details on FS3, see `help combat`.

`combat/start [<mock or real>]` - Starts a combat (default real).
`combat/stop <combat #>` - Stops a combat. 
`combats` - Shows all combats going on. 
`combat/newturn` - Starts the first turn.

`combat/join <list of names>=<combat #>[/<type>]`
        You can set up custom types in the game config to make it easier to add people with certain gear.

`combat/summary` - Summary of everyone's skills/gear/etc. Also shows who hasn't posed or set their actions.

`combat/npc <name>=<level>` - Adjusts a NPC's skill level.  Level can be Goon, Henchman, Boss

`combat/team <name>=<team#>` - Switches teams. 

`combat/ai` - Auto-targets any NPCs who don't have actions yet.
`combat/ai force` - Auto-targets NPCs even if they have an action set.

`combat/unko` - Un-KO's someone who shouldn't have been
`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.

`combat/attackmod <name>=<modifier>` - Gives the combatant a modifier to attack
`combat/defensemod <name>=<modifier>` - Gives the combatant a modifier to defend
`combat/lethalmod <name>=<modifier>` - Gives the combatant a modifier to lethality on damage TAKEN
