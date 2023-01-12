---
toc: 5 - Magic, FS3 Skills, and Combat
summary: Creating and using potions
---
# Potions
Any mage can make potions. They take 1 luck and 48 hours per spell level to make.

See [Potions](/wiki/potions) for more info.

`potion/create <name>` - Create a potion. This spends a luck point.
`luck/give <name>=<reason>` - Give someone a luck point so they can create a potion for you. Specify the potion name in 'reason'.
`item/buy <potion>` - Buy a potion which is available for sale.

`potions [<name>]` - See the potions you or someone else has, as well as in-progress potions.
`potion/give <name>=<potion>` - Give a potion to someone else.

`potion/use <potion>` - Use a potion on yourself.
`potion/use <potion>/<name>` - Use a potion on someone else.

`combat/potion <potion>` - Use a potion on yourself in combat.
`combat/potion <potion>/<name>` - Use a potion on someone else in combat.

`potion/update <name>=<#>/<hours left>` - Admin-only command to adjust the hours left in potion creating.
