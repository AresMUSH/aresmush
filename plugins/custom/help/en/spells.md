---
toc: Magic
summary: Learning & casting spells
---
# Spells
`spells [<name>]` - See a list of your spells or someone else's spells.

`spell/cast <spell>` - Cast a spell that does not require a target.
`spell/cast <spell>=<target>` - Cast a spell that requires a target.
`spell/castmulti <spell>=<target>` - Cast a spell that can have multiple targets.

`spell/cast[multi] <npc>/<spell>[=<target>]` - Make NPCs and other combatants cast in combat.

Shortcuts: cast, castmulti, castm

`spell/learn` <spell> - Spends 1 XP to work toward learning a spell.
`spell/discard` <spell> - Discards a spell. You do not recover any XP, so be sure before doing this.

`spell/request <spell name>=<description>` - Request that a new spell be created. See [Creating Spells](http://spiritlakemu.com/wiki/magic_system) for more information.

## Admin commands
`spell/mod <name>=<mod>` - Set someone's spell mod to affect their spell rolls.
**Tip:** Mods only last for one round.
`spell/hascast <name>=<true/false>` - Changes a character or NPC's 'has cast' value so that they can cast again if they spend luck.
`spell/add <name>=<spell>` - Add a spell to someone's spell list without spending XP.
`spell/remove <name>=<spell>` - Remove a spell from someone's spell list.
