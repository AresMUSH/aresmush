---
toc: FFG Skills
summary: Rolling abilities.
aliases:
- roll
---

# FFG Rolls

Rolling abilities simulates virtual die rolls to tell you the outcome of challenges.  You can make an open-ended roll:

`roll <dice string>`

The dice string can be either an ability name (e.g. `roll Melee`), some dice codes (see below), or a combination of the two.

You can add in extra dice to reflect bonuses and challenges.  

* Positive dice include Boost (B), Ability (A), and Proficiency (P).
* Negative dice include Setback (S), Difficulty (D) and Challenge (C).

So to roll an ability with 2 extra boost dice and 3 extra difficulty dice, you could do:  `roll Melee+2B+3D`.  To roll for a NPC, you could use dice codes like: `roll 2A+1P`.

You can also roll force dice (F) to determine the result of force talents.  For example:  `roll 2F`

## Opposed Rolls

You can automatically factor in an opponent's skill as difficulty dice when doing an opposed skill roll.

`roll <ability>[+<other dice>] vs <character>/<ability>`

> Note: If you're just rolling against an NPC, you can factor their dice into the dice string (e.g. `roll Malee+2D+1C`) and don't need to use the opposed version of the command.