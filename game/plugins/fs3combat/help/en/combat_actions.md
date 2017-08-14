---
toc: FS3 Combat
summary: Choosing actions in combat.
---
# FS3 Combat - Actions

This is a quick reference for combat action commands.  For more details, see [Combat](/help/fs3combat/combat).

> **Tip:** You can always specify a NPC or player name in front of any action command to make them do something.  For example, combat/join Bob=#123.  You need the equals sign even if there are no command options.  For example, combat/pass Bob=
>
> Most commands support multiple names as well, so you can do: combat/attack A B=C

`combat/attack <target>[/<specials, see below>]`

    Specials are optional. Use commas to separate multiple options.
    * burst - Fire a short (3-round) burst. 
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location. 
       Use `combat/hitlocs <target>` to see a list of valid hit locations. 
    * crew - Attack a vehicle crewperson directly instead of the vehicle itself.

`combat/aim <target>` - Takes careful aim.

`combat/reload` – Reloads a weapon.

`combat/treat <name>` - Treat an injured person's worst treatable wound.

`combat/rally <name>` - Rally a knocked out person (without first aid).

`combat/pass` - Take no action this turn.

`combat/fullauto <list of targets>` - Fire a full-auto burst

`combat/explode <list of targets>` - Use an explosive weapon.

`combat/suppress <target>` - Use suppressive fire
    A full-auto or explosive weapon can specify a list of up to 3 targets.

`combat/distract <target>` - Distracts a target

`combat/subdue <target>` - Subdues or disarms a target. 
`combat/escape` – Attempts to escape while subdued.

`combat/randtarget <number of targets>` - Suggests a couple potential targets at random.