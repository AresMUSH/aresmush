---
toc: PF2e
order: 36
summary: Focus Point pool, Refocus, and focus spells by source.
aliases:
- focus
- refocus
---
# Focus Points

Focus Points power **focus spells**. Your pool maximum is usually 1–3 and is set by class features and feats (staff can set the number on the sheet). The first focus spell granted opens a pool of 1 if max was still 0; further increases are feature/staff driven.

Daily preparations (`spells/daily`) restore current Focus Points to max. Casting a focus spell will spend 1 point once the unified cast path is online — until then, track spends with staff tools or by agreement at the table.

## Commands

| Command | Effect |
|---------|--------|
| `focus` | Show current / max and focus spells grouped by magic source |
| `refocus` | Refocus activity: regain **1** Focus Point (up to max) |

`refocus` is available to approved characters. Fictionally it is a 10-minute activity; the command does not advance an in-game clock.

## Staff

    pf2e/set <name>=focus/<n>              # set current (clamped to max)
    pf2e/set <name>=focus/current/<n>      # same
    pf2e/set <name>=focus/max/<n>          # set pool maximum
    pf2e/set <name>=focus/inc              # max +1 (soft cap 3 unless force path later)
    pf2e/set <name>=focus/restore          # current = max
    pf2e/set <name>=magic/focus/<source>/add/<spell>
    pf2e/set <name>=magic/focus/<source>/remove/<spell>

Max of 0 means no focus pool.
