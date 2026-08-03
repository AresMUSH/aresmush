---
toc: Pathfinder 2e
order: 3
summary: Make PF2e ability, skill, save, and attack rolls.
aliases:
- rolls
- roll/job
---
# PF2e - Rolls

> Overview: [Pathfinder 2e](/help/pf2e).

`roll <expression>` - Parse and roll an expression.
`roll <expression> vs <dc>` - Same, with degree of success against a DC.
`roll/job <job#>=<expression>` - Post a roll as a comment on a job.
`roll/job <job#>=<expression> vs <dc>` - Job roll with a DC.

If you are in a scene, a normal `roll` is also added to the scene as an OOC emit.

## Expression basics

Pieces are added and subtracted:

* Dice: `1d20`, `2d6`, `d8`
* Flat numbers: `2`, `-1`
* Ability: `str` `dex` `con` `int` `wis` `cha`
* Skill slug: `athletics`, `stealth`, `lore` (whatever is defined in skills data)
* Save: `fortitude`, `reflex`, `will`, `perception`

If there is **no** `xdY` die in the string, a **1d20** is added automatically.

Examples:

    roll 1d20 + str + 1d6 - 2
    roll athletics
    roll stealth vs 18
    roll fortitude vs 15

## Combat keywords

These resolve from your sheet (and equipped gear where relevant):

| Keyword | Meaning |
|---------|---------|
| `melee` / `attack` | Melee attack mod (equipped melee weapon if any) |
| `ranged` | Ranged attack mod |
| `unarmed` | Unarmed attack mod |
| `spell_attack` | Spell attack mod |
| `class_dc` | Class DC (usable as a DC target) |
| `spell_dc` | Spell DC |

Examples:

    roll melee
    roll ranged vs 20
    roll athletics vs class_dc
    roll 1d20 + spell_attack vs 17

## Job rolls

    roll/job 123=athletics vs 15
    roll/job 45=melee

You must be allowed to comment on that job under normal job permissions.
