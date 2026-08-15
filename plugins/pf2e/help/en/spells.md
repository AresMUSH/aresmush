---
toc: PF2e
order: 40
summary: Spellcasting sources, daily prep, prepare/learn, and innate spells.
aliases:
- spells
- spell
- innate
- spells/cast
- spells/daily
- spells/prepare
- spells/learn
---
# Spells and Innate Magic

Spellcasting is tracked per **source** on the sheet (`wizard`, `cleric`, a dedication slug, or `innate`). Multiclass characters can have more than one source; rolls and prepare/learn need a source when more than one exists.

## Commands

| Command | Effect |
|---------|--------|
| `spells` | Show all spellcasting sources, slots, lists, and innate grants |
| `spells/daily` | Daily preparations: clear spent slots, restore innate uses, restore Focus Points |
| `spells/prepare [<source>=]<rank>/<spell> [spell...]` | Set prepared spells for a rank (prepared casters) |
| `spells/learn [<source>=]<spell> [rank]` | Add a spell to spellbook / repertoire / cantrips |
| `spells/cast <slug>` | Cast an **innate** spell (spends a daily use if limited) |

Focus Points still use `focus` / `refocus` when those commands are enabled; daily prep also restores focus when the sheet has focus spells.

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

Ancestry and heritage YAML may list automatic grants:

```yaml
innate_spells:
  - slug: detect_magic
    tradition: arcane
    frequency: at_will
    rank: 0
```

Those apply when features are refreshed (identity commit, staff ancestry/heritage/level set).

## Staff seed (class slots)

    pf2e/set Bob=magic/sync
    pf2e/set Bob=magic/source/wizard/seed
    pf2e/set Bob=magic/learn/wizard/force_barrage
    pf2e/set Bob=magic/daily
    pf2e/set Bob=magic/proficiency/wizard/E

See also `help manage pf2e` for the full staff path list.
