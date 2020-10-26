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
In combat, you can specify a NPC name in front of any action command to make them do something.  For example, combat/weapon Otho=claws; combat/attack Otho/Bob; spell/cast Otho/Hot Hands=Bob.

Temporary NPCs can cast any spell and use any potion. Be wise about doing so. It is good GM form to create a spell and potion list for your own use before starting combat. NPCs should not use spells that are higher than their level.

`combat/join <list of names>=<combat #>[/<type>]` - Creates temporary NPCs and adds them to the combat. 'Type' affects their available hitlocs. See `combat/types` for a list.
`combat/npc <name>=<level>` - Level can be One, Two, Three, Four, Five, Six, Seven, Eight, Nine, or Ten. These correspond very roughly with the number of dots to be reasoably successful at the same level of spells (IE, if you want an NPC who can cast level 7 spells, you want a level seven or eight NPC)

## Rolling for NPCs

For NPCs, you can specify a skill rating (e.g. roll 4).  Note that the code automatically factors in an average attribute (2 dots).

`roll <NPC>/<skill rating>`
`roll <NPC>/<skill rating> vs <character>/<skill>[+<attribute>]`


## Spells Out of Combat

`spell/npc <npc>/<dice>=<spell>[/<target> <target>]` - Have an NPC cast a spell. NPCs can cast any spell. The dice chosen should reflect their Magic attribute + their School rating.

Spells which would be stopped by a shield (Endure Cold, Endure Fire, Mind Shield) should work automatically in a check. Remember that shields are stored different in and out of combat, though, so if you start or stop combat, they will no longer be set appropriately.
