---
toc: FS3
summary: Taking actions in combat scenes.
aliases:
- attack
- attacks
- stance
- actions

---
# FS3 Combat Actions
## PREPARING
Preparing actions do not take up a turn unless they are accomplished via spell or potion.

### Stance
`combat/stance <stance>` - Sets stance for your actions.

### Gear

`weapons` - List all weapons.
`weapon <name>` - See details for a particular weapon.
`combat/weapon <name+specials>` - Sets your weapon.

`armor` - List all types of armor.
`armor <name>` - See details for a particular armor type.
`combat/armor <name+specials>` - Sets your armor.

### Luck
Luck points have special effects in combat. (see [Luck](/help/luck))

`combat/luck <attack, defense or initiative>` - Spend a luck point to get +3 bonus dice this turn.
**Tip:** Spending luck on attack affects special attacks like explosions or suppression.  It also conveys a bonus to damage.

## TAKING A TURN
`combat/pass` - Take no action this turn.

### Magic
`spell/cast <spell>` - Casts a spell that doesn't need a target.
`spell/cast <spell>=<target>` - Casts a spell that needs a target.
`potion/use <potion>` - Uses a potion.

### Attacks
`combat/attack <target>[/<specials, see below>]`
    Specials are optional. Use commas to separate multiple options.
    * mod:<special modifiers> - Dice to add or subtract to the roll.
    * called:<location> - Perform a called shot to a particular hit location.
       Use `combat/hitlocs <target>` to see a list of valid hit locations.

`combat/explode <list of targets>` - Use an explosive weapon.

`combat/aim <target>` - Takes careful aim.
`combat/distract <target>` - Distracts a target
`combat/subdue <target>` - Subdues or disarms a target.
`combat/escape` – Attempts to escape while subdued.

### Healing & Reviving
`combat/treat <name>` - Treat an injured person's worst treatable wound. (requires medicine)
`combat/rally <name>` - Rally a knocked out person (without first aid).
`combat/hero` - Spends a luck point to un-KO yourself. This doesn't erase the damage, it just lets you soldier on in spite of it.
