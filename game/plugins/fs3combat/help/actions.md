---
topic: combat actions
toc: FS3 Combat
summary: Run-down of all combat actions.
categories:
- main
aliases:
- actions
---
This is a quick reference for combat action commands.  For more details on FS3, see the game wiki or `help combat`.

`combat/attack <target>[/<specials, see below>]`

    Specials are optional. Use commas to separate multiple options.
    * burst - Fire a short (3-round) burst. 
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location. 
       Use `combat/hitlocs <target>` to see a list of valid hit locations. 
    
`combat/aim <target>` - Takes careful aim.

`combat/reload` – Reloads a weapon.

`combat/treat <name>` - Treat an injured person.

`combat/pass` - Take no action this turn.

`combat/fullauto <list of one or more targets, separated by commas>` - Fire a 
   fully automatic (10-round) burst.  You can list up to 5 separate targets.
   
`combat/suppress <target>` - Use suppressive fire
    A full-auto weapon can specify a comma-separated list of up to 5 targets.
    
`combat/subdue <target>` - Subdues or disarms a target. 
`combat/escape` – Attempts to escape while subdued.

`combat/explode <right next to>/<nearby>` - Uses an explosive weapon.
   Each group should specify a comma-separated list of targets.
