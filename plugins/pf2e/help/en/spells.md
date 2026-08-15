---
toc: PF2e
order: 40
summary: Spellcasting sources, daily prep, prepare/learn, cast (slots, focus, innate).
aliases:
- spells
- spell
- cast
- innate
- spells/cast
- spells/daily
- spells/prepare
- spells/learn
---
# Spells and Innate Magic

Spellcasting is tracked per **source** on the sheet (`wizard`, `cleric`, a dedication slug, or `innate`). Multiclass characters can have more than one source; rolls and prepare/learn/cast need a source when more than one exists.

## Commands

| Command | Effect |
|---------|--------|
| `spells` | Show all spellcasting sources, slots, lists, and innate grants |
| `spells/daily` | Daily preparations: clear spent slots, restore innate uses, restore Focus Points |
| `spells/prepare [<source>=]<rank>/<spell> [spell...]` | Set prepared spells for a rank (prepared casters) |
| `spells/learn [<source>=]<spell> [rank]` | Add a spell to spellbook / repertoire / cantrips |
| `spells/cast` / `cast` | Cast a spell (see below) |

## Casting

```
cast <spell>
cast <spell> <rank>
cast <source>=<spell>
cast <source>=<spell> <rank>
spells/cast ...   (same)
```

**What it does**

| Kind | Resource | Notes |
|------|----------|--------|
| **Innate** | Daily uses (or at-will) | Prefer `innate` source if the slug is only innate |
| **Focus** | 1 Focus Point | Slug must be on a source's `focus_spells` list |
| **Cantrip** | None | Must be on the source cantrip list |
| **Prepared** | Slot at cast rank | Must be **prepared at that rank** |
| **Spontaneous** | Slot at cast rank | Must be in **repertoire**; rank may be heightened |

Heightening: pass a rank higher than the spell's base rank (spontaneous) or prepare the spell at the higher rank (prepared).

Cast emits OOC to the room and, if you are in an open scene, logs to the scene.

Follow with `roll spell_attack` / `roll spell_dc` (or `spell_dc:<source>`) when the table needs a check.

Focus Points also use `focus` / `refocus`; daily prep restores focus when the sheet has a pool.

## Rolling spell DC / attack

In `roll` expressions:

- `spell_dc` / `spell_attack` — only source, or error if multiple
- `spell_dc:wizard` / `spell_attack:innate` — explicit source

Innate DC and attack use Charisma by default (or a per-spell attribute), Trained proficiency (Expert at level 12+), raised to class spellcasting proficiency when higher.

## Innate spells

Innate grants live under the `innate` magic source. They do **not** use spell slots.

- **At-will** — no use counter
- **Per day** — `used` / `per_day`; refreshed by `spells/daily`

Staff grant:

    pf2e/set Bob=magic/innate/add/detect_magic/arcane/0/at_will
    pf2e/set Bob=magic/innate/add/heal/divine/1/per_day/1
    pf2e/set Bob=magic/innate/remove/detect_magic

Ancestry and heritage YAML may list automatic grants under `innate_spells` (applied on identity commit / feature refresh).

## Staff seed (class slots)

    pf2e/set Bob=magic/sync
    pf2e/set Bob=magic/source/wizard/seed
    pf2e/set Bob=magic/learn/wizard/force_barrage
    pf2e/set Bob=magic/daily
    pf2e/set Bob=magic/proficiency/wizard/E

See also `help manage pf2e` for the full staff path list.
