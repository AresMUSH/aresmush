---
topic: combat actions
toc: FS3 Combat
summary: Run-down of all combat actions.
categories:
- main
aliases:
- actions
plugin: fs3combat
---
This is a quick reference for combat action commands.  For more details on FS3, see `help combat`.

`combat/attack <target>[/<specials, see below>]`

    Specials are optional. Use commas to separate multiple options.
    * burst - Fire a short (3-round) burst. 
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location. 
       Use `combat/hitlocs <target>` to see a list of valid hit locations. 
    * crew - Attack a vehicle crewperson directly instead of the vehicle itself.

`combat/aim <target>` - Takes careful aim.

`combat/reload` – Reloads a weapon.

`combat/treat <name>` - Treat an injured person.

`combat/pass` - Take no action this turn.

`combat/suppress <target>` - Use suppressive fire
    A full-auto or explosive weapon can specify a list of up to 5 targets.

`combat/subdue <target>` - Subdues or disarms a target. 
`combat/escape` – Attempts to escape while subdued.