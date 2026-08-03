---
toc: Pathfinder 2e
order: 4
summary: Build a PF2e sheet during chargen.
aliases:
- cg
- pf2e_chargen
---
# PF2e - Chargen

> Overview: [Pathfinder 2e](/help/pf2e).

All `cg` commands are **blocked for approved characters**. Use staff tools after approval.

## Flow

1. `cg/start` — ensure a sheet exists
2. **Stage A (unlocked)** — pick ancestry, heritage, background, class; review with `cg/identity`
3. `cg/commit` — lock identity, apply fixed grants, grant starting wealth
4. **Stage B (locked)** — boosts, background skill choices, free skills, languages, feats
5. If you need to restart before approval: `cg/reset confirm`

## Stage A — identity

`cg/start` - Create/ready a blank PF2e sheet.
`cg/ancestry` - List ancestries.
`cg/ancestry <slug>` - Set ancestry.
`cg/heritage` - List heritages (filtered by current ancestry when set).
`cg/heritage <slug>` - Set heritage.
`cg/background` - List backgrounds.
`cg/background <slug>` - Set background.
`cg/class` - List classes.
`cg/class <slug> [<key ability>]` - Set class (key ability required when the class offers a choice).
`cg/identity` - Show current combination and what it grants.
`cg/commit` - Lock identity. Applies fixed skills/saves/feat/languages/features and **starting wealth**.
`cg/reset confirm` - Wipe the sheet and unlock Stage A (chargen only).

You may freely change Stage A picks until commit. After commit, changing identity requires `cg/reset`.

## Stage B — after commit

`cg/boost <ancestry|heritage|background> <ability> [ability...]` - Assign free boosts for a source. You cannot boost the same ability twice from one source.
`cg/bgskill` - Show pending background skill choices.
`cg/bgskill <option>` - Resolve the next background skill choice (including lore specialties and paired skill-feat options).
`cg/skill` - Show skill pick status.
`cg/skill <skill> [skill...]` - Spend free skill trainings.
`cg/language` - Show known languages and free picks.
`cg/language <slug>` - Spend a free language pick.
`cg/feat` - List eligible feats / open slots (see command output).
`cg/feat <slug> [<slot>]` - Take a feat (specify slot if more than one open type matches).
`cg/unfeat <slug>` - Remove a feat you chose (granted background feats stay locked).

## Feat slots

Remaster slot types: **ancestry**, **general**, **class**, **skill**. A feat may be legal in more than one category; the command spends a matching open slot.

## Dedication policy

* First dedication: player tools OK
* Second: staff approval only (`pf2e/set`)
* Third: not allowed

## Starting wealth

On `cg/commit`, starting wealth (default **15 gp**) is placed on the **Society account**. Withdraw to your purse before shopping. See [Money](/help/money) and [Shop](/help/shop).
