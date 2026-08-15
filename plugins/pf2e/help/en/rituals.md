---
toc: PF2e
order: 38
summary: Ritual lookup and primary skill checks.
aliases:
- ritual
- rituals
---
# Rituals

Rituals are **not** spell slots, focus, or innate. They are timed activities resolved with skill checks at the table. Catalog data lives in `spells_rituals.yml` (category: ritual).

## Commands

| Command | Effect |
|---------|--------|
| `rituals` | List rituals (paginated, 5 per page) |
| `rituals <text\|rank>` | Search by name/text or rank number |
| `rituals/info <slug>` | Detail line (DC, cast time, optional skills/cost) |
| `rituals/check <slug> [skill]` | Primary skill check vs ritual DC |
| `rituals/check <slug>=<skill>` | Same |

`rituals/cast` is an alias of `rituals/check` — it does **not** auto-apply effects or spend money.

## DC

Default DC is **very hard** at level band `rank × 2` (capped 20), using the same simple DC table as the rest of the plugin. Override per ritual in YAML with `dc: N` when the book lists a fixed number.

## Optional data keys

Enrich entries over time:

```yaml
consecrate:
  primary_skill: religion   # or primary_skills: [religion, occultism]
  min_proficiency: T
  cost_gp: 11
  secondary_casters: 1
  dc: 20                    # optional fixed override
```

If no primary skill is in data, you must pass the skill on `rituals/check`.

## What is not automated

Secondary caster checks, material costs, days of casting, and success effects stay narrative / staff. Primary check is the coded piece for table pace.
