---
toc: ~admin~ Managing the Game
order: 40
summary: Staff tools for PF2e sheets, coin, and Society gear.
aliases:
- pf2e/set
- pf2e/reset
- manage_pf2e
---
# Managing PF2e

> **Permission:** `manage_pf2e` for mutations. Viewing another PC's sheet requires `view_sheet` (commonly granted to Storyteller).

Staff tools are **CLI-only** by design.

## View sheets

`sheet <name>` / `sheet/combat <name>` — requires `view_sheet` when looking at someone else.

## Reset

`pf2e/reset <name>=confirm` - Wipe a character's PF2e sheet to defaults (identity unlocked).

## Set fields

`pf2e/set <name>=<field>/<value>[/...]`

### Common fields

| Path | Effect |
|------|--------|
| `level/<n>` | Set level; refresh features/HP |
| `skill/<slug>/<rank>` | Set skill TEML (default T) |
| `save/<slug>/<rank>` | Set save/Perception rank |
| `ability/<abil>/<score>` | Set current ability score |
| `ability/<abil>/base/<n>` or `.../current/<n>` | Set base or current |
| `feat/add/<slug>[/<slot>]` | Add feat (staff dedication limits apply) |
| `feat/remove/<slug>` | Remove feat |
| `feature/add/<slug>` / `feature/remove/<slug>` | Features list |
| `language/add/<slug>` / `language/remove/<slug>` | Languages |
| `hp/current/<n>` `hp/max/<n>` `hp/temp/<n>` | Hit points |
| `speed/<n>` `hero/<n>` `focus/<n>` | Resources |
| `ancestry/<slug>` `heritage/<slug>` `background/<slug>` | Identity pieces |
| `class/<slug>[/<key abil>]` | Class |
| `identity/lock` / `identity/unlock` | Chargen lock flag |

### Money

Default destination for grants is the **Society account**.

    pf2e/set Bob=money/grant/10gp
    pf2e/set Bob=money/grant/society/5gp
    pf2e/set Bob=money/grant/purse/2gp
    pf2e/set Bob=money/remove/1gp

### Society items (requisition / brokerage)

Grants are marked `[Society]`.

    pf2e/set Bob=item/add/longsword
    pf2e/set Bob=item/add/longsword/potency:1/striking:1
    pf2e/set Bob=item/custom/weapon/Asra's_Edge/bulk:1/potency:1
    pf2e/set Bob=item/runes/i3/potency:1/property:flaming
    pf2e/set Bob=item/magic/i3/invested:true/level:5
    pf2e/set Bob=item/notes/i3/Hall_plot_issue
    pf2e/set Bob=item/remove/i3

Players cannot sell Society or unique items to mundane vendors. There is no coded Hall gear locker — physical items stay on the PC.
