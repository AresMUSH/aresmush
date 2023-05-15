---
toc: 5 - Magic, FS3 Skills, and Combat
summary: Damage and healing in combat.
aliases:
- treat
- heal
- healing
- combat_damage
---

# Damage

The damage commands are part of the FS3Combat system.

> Learn how the combat system works in the [Combat Tutorial](/help/fs3combat_tutorial).

`damage` - Views your damage.
`damage <name>` - Views someone else's damage.

> **Note:** The healing progress bar on the damage display just shows how close you are to reducing the wound by one level. It may take several levels before you're fully healed.

## Magical Healing

> **Note:** Magical healing only works soon after an injury, and only affects a single wound.

`spell/cast <spell>[/target]` - Casts a healing spell outside of combat.
`combat/cast <spell>[/target]` - Casts a healing spell inside of combat.

For a list of healing spells, choose Effect: Heal on the [spell search](/search-spells) page.

## Treating

> **Note:** Treating only works soon after an injury, and only affects a single wound.  Inside combat, you use `combat/treat <name>` instead.

`treat <name>` - Treats someone's wounds with immediate first aid.

## Healing

> **Note:** Healing is more of ongoing care, like a nurse or doctor might give. You will continue healing someone until they are well.

`heal/start <name>` - Takes someone as a patient.
`heal/stop <name>` - Removes a patient.
`heal/list` - Shows your patients.
`heal/scan` - Find injured patients who might need your services.

## Automatic Healing

Damage heals in increments automatically overnight.

## Adjusting Damage

Admins and characters with the `manage_combat` permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<initial severity>/<current severity>/<IC date>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.