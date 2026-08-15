---
toc: PF2e
order: 37
summary: Scrolls, wands, and staves — inventory spell items.
aliases:
- scroll
- wand
- staff
- activate
---
# Spell Items

Scrolls, wands, and staves live in **inventory** as instances with a `spell` payload. They are not a fourth spell list on the sheet.

## Types

| Kind | Behavior |
|------|----------|
| **Scroll** | One cast; qty decreases (destroyed at 0). Stackable if identical. |
| **Wand** | Charges (default 1). Restored on `spells/daily` when `daily: true`. Unique. |
| **Staff** | Multi-spell list + optional cantrips. Spend charges equal to cost (usually rank). Cantrips cost 0. Daily restore by default. Unique. |

## Activate

    gear/activate <item_id>
    gear/activate <item_id> <spell>     # required for multi-spell staves
    gear/use <item_id> ...              # alias

Must not be stowed. Returns the spell slug, rank, DC, and attack bonus for table use (does not auto-resolve damage or saves).

- If you have a spellcasting source whose tradition matches the item, **your** DC/attack are used.
- Otherwise a flat item DC/attack from the stored rank is used (no Trick Magic Item feat automation yet).

## Catalog samples

`data/items_spell.yml` (merged into `items`): `scroll_heal_1`, `scroll_fireball_3`, `wand_heal_1`, `staff_fire`, etc.

    gear/add scroll_fireball_3
    shop/buy … (if stocked on a vendor)

## Staff grants (manage_pf2e)

    pf2e/set <name>=item/spell/<catalog_slug>
    pf2e/set <name>=item/scroll/<spell>/<rank>/[tradition]
    pf2e/set <name>=item/wand/<spell>/<rank>/[tradition]/[charges_max]
    pf2e/set <name>=item/staff/<Label>/<tradition>/<charges>/<spell>:<rank>[:cost]...
    pf2e/set <name>=item/staff/Fire/arcane/5/cantrip:ignition/fireball:3:3

Society-flagged by default on staff grants.

## Daily prep

`spells/daily` restores wand/staff charges where `daily: true`, in addition to slots, innate uses, and Focus Points.
