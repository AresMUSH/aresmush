---
toc: Magic
summary: Learning & casting spells
---
# Spells
`spells [<name>]` - See a list of your spells or someone else's spells, including spells you are learning.

`spell/cast <spell>[+/-mod]` - Cast a spell on yourself, the environment, or an object.
`spell/cast <spell>=<target>[<target> <target>][+/-mod]` - Cast a spell on one or more targets.
Mods only work outside of combat. In combat, use `spell/mod`.
`shield/off <shield>` - Out of combat, turn off a shield such as Mind Shield, Endure Fire, or Endure Cold.

`spell/cast <npc>/<spell>[=<target>]` - Make NPCs and other combatants cast in combat.

**Tip**: You can use `cast` instead of `spell/cast`

`combat/luck spell` - Spend Luck to gain a +3 dice bonus to your spellcasting for one round.
Out of combat, you can add +mod to the end of your spell to cast using a modifier.

`spell/luck <spell>` - Spend 2 luck to remove a week from a spell's learn time and learn it again immediately.
`spell/learn <spell>`  - Spends 1 XP to work toward learning a spell.
`spell/discard <spell>`  - Discards a spell. You do not recover any XP, so be sure before doing this.

`spell/request <spell name>=<description>` - Request that a new spell be created. See [Creating Spells](http://spiritlakemu.com/wiki/magic_system) for more information.

## Combat Organizer Commands
`spell/mod <name>=<mod>` - Set someone's spell mod to affect their spell rolls.
**Tip:** Mods only last for one round.

## Admin commands
`spell/add <name>=<spell>` - Add a spell to someone's spell list without spending XP.
`spell/remove <name>=<spell>` - Remove a spell from someone's spell list.
`shield/off <name>=<shield>` - Out of combat, turn off someone's shield such as Mind Shield, Endure Fire, or Endure Cold.
