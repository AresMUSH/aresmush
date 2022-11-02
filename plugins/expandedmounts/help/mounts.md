---
toc: FS3 Skills and Combat
summary: Participating in combat scenes.
aliases:
- mount
---

`mounts` - List all mounts and their mages
`damage <mount>` - See the damage for a mount

## Combat

`combat/mount <name>` - Mount a mythic in combat
`combat/dismount` - Dismount a mythic in combat

## Rolling

`mount/roll <roll/options>` - Roll a skill taking your mount's stats into account.
`mount/roll <character>/<roll options>` - Make a roll for someone else taking their mount's stats into account.
`mount/roll <character>/<roll options> vs <character>/<roll options>` - Makes an opposed roll taking mount stats into account.

In all cases, `<roll options>` can be a combination of ability, ruling attribute, modifiers, or NPC dice.  For example, `roll Alertness` or `roll Alertness+Wits-1` or `roll 4` (which rolls ability 4+attr 2). For details and examples, see the [tutorial](/help/fs3).

For opposed rolls, it will always assume BOTH parties are using their mount's stats.
