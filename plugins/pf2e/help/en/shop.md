---
toc: Pathfinder 2e
order: 7
summary: Buy and sell mundane gear from vendors.
aliases:
- vendor
- vendors
- buy
- sell
---
# PF2e - Shop

> Overview: [Pathfinder 2e](/help/pf2e).

Mundane vendors sell catalog armor, weapons, gear, and alchemical items. Payment is **purse only** — withdraw from the Society account first if needed.

`shop` - List vendors.
`shop <vendor>` - List that vendor's stock and prices (in sp).
`shop/buy <vendor> <slug> [qty]` - Buy into inventory.
`shop/sell <item_id> [qty]` - Sell a mundane catalog item for **half** price (floor).

## Sell restrictions

You cannot sell:

* Society-flagged gear (turn it in through staff)
* Unique, runed, or magic items
* Equipped items (unequip first)
* Stowed items (retrieve first)
* Items with no catalog price

## Examples

    shop
    shop general
    shop/buy general backpack
    shop/buy weaponsmith longsword 1
    money/withdraw 15gp
    shop/buy armorer leather_armor
    shop/sell i7
