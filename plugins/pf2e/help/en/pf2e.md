---
toc: Pathfinder 2e
order: 1
tutorial: true
summary: Pathfinder 2e (Remaster) system overview.
aliases:
- pf2
- pathfinder
- pathfinder2e
---
# Pathfinder 2e

This game uses **Pathfinder 2e (Remaster / Player Core)** for character building, checks, and table-style combat support. The engine is edition-neutral math with Remaster names as the data source of truth.

[[toc]]

## What is coded

* Character sheets (full and combat)
* Ability, skill, save, Perception, attack, class DC, and spell DC rolls
* Chargen identity lock, boosts, skills, languages, and feats
* Coin purse, Society account, encumbrance
* Inventory, bags (stow/retrieve), mundane vendors
* Staff tools to fix sheets and issue Society gear

Combat is **not** fully automated. Rolls and sheet numbers support table play; you still narrate the fight.

## Quick command map

| Area | Start here |
|------|------------|
| Sheet | `sheet`, `sheet/combat` (or `csheet`) |
| Rolls | `roll` |
| Chargen | `cg/start`, then [Chargen](/help/chargen) |
| Money | `money` |
| Gear | `gear` (also `inv` / `inventory`) |
| Shops | `shop` |
| Feats list | `feats` |
| Staff | [Managing PF2e](/help/manage_pf2e) |

## Degrees of success

When a roll includes a DC (`roll athletics vs 15` or `roll melee vs 20`), the system reports **critical success / success / failure / critical failure**, including the natural 20 / natural 1 adjustments used by PF2e.

## Proficiency

Ranks use TEML letters: **U** Untrained, **T** Trained, **E** Expert, **M** Master, **L** Legendary. Trained+ adds proficiency bonus + level to the relevant check.

## Society economy notes

* **Purse** — physical coin on your person (counts toward Bulk when encumbrance is on).
* **Society account** — Hall ledger for your character. Not physical coin; not Bulk. Withdraw to the purse before buying from shops.
* Starting wealth is granted at `cg/commit` into the Society account by default (configurable).
* There is **no** Hall storage for bags or gear. Everything physical stays on your sheet and counts toward load.

## Command reference

[Character Sheet](/help/sheet)
[Rolls](/help/roll)
[Chargen](/help/chargen)
[Money](/help/money)
[Gear](/help/gear)
[Shop](/help/shop)
[Feats](/help/feats)
[Managing PF2e](/help/manage_pf2e) (staff)
