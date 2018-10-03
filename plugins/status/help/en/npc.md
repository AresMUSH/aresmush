---
toc: ~admin~ Managing the Game
summary: Designating a character as a NPC.
alias:
- NPCs
- combat_npc
---
# NPCs
Most of the time NPCs will be temporary creations that only live in combat. These NPCs have no spell or potion lists and can be adjusted easily. Sometimes, a recurring NPC will be a character object that operates under the same restrictions as PCs.

`npc <name>=<on or off>` - Admin-only command to mark a character as a staff-run NPC.

##Combat
In combat, you can specify a NPC name in front of any action command to make them do something.  For example, combat/weapon Otho/claws; combat/attack Otho/Bob; spell/cast Otho/Hot Hands=Bob.

Temporary NPCs can cast any spell and use any potion. Be wise about doing so. It is good GM form to create a spell and potion list for your own use before starting combat. NPCs should not use spells that are higher than their level.

`combat/join <list of names>=<combat #>[/<type>]` - Creates temporary NPCs and adds them to the combat. 'Type' affects their available hitlocs. See `combat/types` for a list.
`combat/npc <name>=<level>` - Level can be One, Two, Three, Four, Five, Six, Seven, Eight, Nine, or Ten. Levels Seven-Ten are Miniboss to Boss levels.

## Rolling for NPCs

For NPCs, you can specify a skill rating (e.g. roll 4).  Note that the code automatically factors in an average attribute.
