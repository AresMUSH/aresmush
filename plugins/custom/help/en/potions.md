---
toc: Magic
summary: Creating and using potions
---
# Potions
Potions can only be made from certain spells marked in the database. They take 1 luck and 48 hours per spell level to make. You may spend luck to have someone else make a potion for you, if they agree.

 See [Creating Potions](http://spiritlakemu.com/wiki/magical_items) for more info.

`potion/create <name>` - Create a potion. This spends a luck point.
`luck/spend <reason>` - Spend a luck to have someone else create a potion for you.

`potions [<name>]` - See the potions you or someone else has, as well as in-progress potions..
`potion/give <name>=<potion>` - Give a potion to someone else.

`potion/use <potion>` - Use a potion on yourself.
`potion/use <potion>=<name>` - Use a potion on someone else.

**Admin only**
`potion/add <name>=<potion>` - Adds a potion to a character.
`potion/update <name>=<#>/<hours left>` - Adjust the hours left in potion creating.
`luck/award <name>=<num>/<reason>` - Adds a luck point to a character so they can create a potion for someone else.
