---
toc: Fate Skills
summary: Rolling abilities.
aliases:
- roll
---

# Fate Rolls

Rolling abilities simulates virtual die rolls to tell you the outcome of challenges.

`roll <dice string>`

The dice string can be either a skill name (e.g. `roll Fight`) or an ability level (to simulate NPCs - e.g. `roll Good`).  

You can also factor in modifiers to the roll (e.g. `roll Fight+2` or `roll Fight-1`).

To make an opposed roll against another character, use the 'vs' version of the command:

`roll <dice string> vs <character>/<dice string>`

> Note: NPCs don't have skill ratings, so if you're doing an opposed roll against a NPC be sure to specify a rating name or number like Good or 3.  Otherwise the system will assume Mediocre.