---
toc: PF2e
order: 35
summary: Focus Points pool, Refocus, and casting costs.
aliases:
- focus
- refocus
---
# Focus Points

PF2e Focus Points power **focus spells**. Your pool has a maximum set by class features and feats (usually 1–3). Staff set the max on your sheet; daily preparation restores you to full.

## Commands

| Command | Effect |
|---------|--------|
| `focus` | Show current / max Focus Points |
| `refocus` | Perform the Refocus activity: regain **1** Focus Point (up to max) |

Refocus is a 10-minute activity in the fiction. The command spends no in-game time tracker — use it when your scene supports the activity.

## Spending Focus

Casting a focus spell costs 1 Focus Point. When the full spellcasting commands are live, they call the same spend helper. You cannot cast if the pool is empty.

## Staff

    pf2e/set <name>=focus/<n>           # set current (clamped to max)
    pf2e/set <name>=focus/max/<n>       # set pool maximum
    pf2e/set <name>=focus/current/<n>   # same as focus/<n>
    pf2e/set <name>=focus/restore       # restore current to max (daily prep)

Max of 0 means the character has no focus pool.
