---
toc: FS3 Skills and Combat
summary: Participating in combat scenes.
aliases:
order: 1
---
# FS3 Combat
The FS3 Combat system is designed to bring some order to the chaos of large combat scenes, managing ability rolls and tracking damage in an automated fashion.

The FS3 Combat system is designed to bring some order to the chaos of large combat scenes.

> Learn how the combat system works in the [Combat Tutorial](/help/fs3combat_tutorial).

## Actions

> **Tip:** You can always specify a NPC or player name in front of any action command to make them do something.  For example, combat/join Bob=#123.  You need the equals sign even if there are no command options.  For example, combat/pass Bob=
>
> Most commands support multiple names as well, so you can do: combat/attack A B=C

`combat/stance <stance>` - Sets stance for your actions.  You can use `combat/stances` to see a list of possible stances.

`combat/attack <target>[>mod:<mod>] OR [>called:<hitloc>]`

    Specials are optional. Use commas to separate multiple options.
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location.
       Use `combat/hitlocs <target>` to see a list of valid hit locations.

`combat/spell <spell>[/<target> <target>]` - Cast a spell in combat. Spells with no target will cast on the environment or the caster.

`combat/potion <potion>[/<target>]` - Use a potion in combat.

`combat/aim <target>` - Takes careful aim.

`combat/treat <name>` - Treat an injured person's worst treatable wound.

`combat/rally <name>` - Rally a knocked out person (without first aid).

`combat/pass` - Take no action this turn.

`combat/explode <list of targets>` - Use an explosive weapon.

`combat/distract <target>` - Distracts a target

`combat/subdue <target>` - Subdues or disarms a target.
`combat/escape` – Attempts to escape while subdued.

`combat/randtarget <number of targets>` - Suggests a couple potential targets at random.

## Gear

> **Note:** There are various kinds of gear that can be used in combat. You should only use gear that is appropriate to the IC situation.

`weapons` - List all weapons.
`weapon <name>` - See details for a particular weapon.
`combat/weapon <name+specials>` - Sets your weapon.

`armor` - List all types of armor.
`armor <name>` - See details for a particular armor type.
`combat/armor <name+specials>` - Sets your armor.

## Luck

`combat/luck <attack, defense or initiative>` - Spend a luck point this turn.
`combat/hero` - Spends a luck point to un-KO yourself and receive a small amount of healing.

## Organizing

See [Organizing Combat](/help/combat_org)
