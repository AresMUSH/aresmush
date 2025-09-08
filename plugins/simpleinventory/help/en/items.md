---
toc: Inventory
summary: Using and seeing items.
aliases:
- items
- equip
- unequip
- inventory
- simple_inventory
---
# Items
Items in the simple inventory are informational only. They do not carry any coded effect other than to denote ownership. Only one item may be equipped at a time.

`items [<name>]` - See the items owned by a character and what they have equipped.
`item/equip <item>` - Equip an item.
`item/unequip <item>` - Unequip an item.
`item/give <name>=<item>` - Give an item to someone.
`item/buy <item>` - Buy an item which is available for sale. 

**Admin Only**
`item/add <name>=<item>` - Add an item to someone.
`item/remove <name>=<item>` - Remove an item from someone.

Note that temporary NPCs cannot use items. To use an item, NPCs need to be character objects. See [help NPCs](/help/npc).
