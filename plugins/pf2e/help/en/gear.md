---
toc: Pathfinder 2e
order: 6
summary: Inventory, equip, bags, and encumbrance.
aliases:
- inv
- inventory
- stow
- retrieve
---
# PF2e - Gear

> Overview: [Pathfinder 2e](/help/pf2e).

`gear` / `inv` / `inventory` - Show equipped, carried, and stowed gear, plus purse/Society and Bulk when encumbrance is on.

## Manipulate items

Items are referenced by **instance id** (for example `i3`), shown on the gear list.

`gear/add <slug> [qty]` - Add a catalog item (player path; mundane catalog only).
`gear/drop <id> [qty]` - Remove an item (or part of a stack).
`gear/equip <id>` - Equip/wear/wield. Equipping armor or a shield auto-unequips the previous one of that kind. Cannot equip while stowed.
`gear/unequip <id>` - Unequip.
`gear/stow <item_id> <bag_id>` - Put an item into a container you carry.
`gear/retrieve <item_id>` - Take an item out of its container.

Shortcuts: `inv/add`, `inv/drop`, `inv/equip`, `inv/unequip`, `inv/stow`, `inv/retrieve` (and the same with `inventory/...`).

## Bags

Containers (backpacks, etc.) have capacity and may ignore some Bulk of contents when worn. **Bags always stay on you** — there is no Hall storage for gear. Society-flagged items may be stowed like anything else; the load still sits on your character.

Rules of thumb:

* Unequip before stowing
* Retrieve before equipping or selling
* Containers cannot be nested inside other containers

## Markers on the list

* `*` — unique (magic, runed, or one-off)
* `[Society]` — issued or brokered through the Hall (staff path)
* `in i3` — currently stowed in that bag

## Combat impact

Equipped armor feeds **AC**. Equipped weapons feed **melee/ranged** attack keywords and combat-sheet weapon line. See [Rolls](/help/roll).

## Society gear

Magic, runed, and plot items are granted by staff (`pf2e/set`), not by player `gear/add` or the shop. They cannot be sold to mundane vendors.
