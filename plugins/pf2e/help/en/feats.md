---
toc: Pathfinder 2e
order: 8
summary: Browse the feat list and chargen feat tools.
aliases:
- feat
- feat_search
---
# PF2e - Feats

> Overview: [Pathfinder 2e](/help/pf2e). Chargen: [Chargen](/help/chargen).

`feats` - Browse feats (paginated, alphabetical by name).
`feats <text>` - Search by name or text.

During chargen (after `cg/commit`):

`cg/feat` - Eligible feats / slot status for your sheet.
`cg/feat <slug> [<slot>]` - Take a feat, spending a matching open slot when required.
`cg/unfeat <slug>` - Remove a player-chosen feat.

Prerequisites (ability scores, skill ranks, other feats, minimum level) are checked automatically. Background-granted feats cannot be removed without `cg/reset`.

## Slot types

* ancestry
* general
* class
* skill

Some feats can fill more than one type. If more than one open slot matches, specify the slot on the command.

## Archetype dedications

One dedication via player tools. A second needs staff. A third is not approved. See [Chargen](/help/chargen).
