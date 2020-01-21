---
toc: FS3 Skills and Combat
summary: Damage and healing in combat.
aliases:
- treat
- heal
- healing
- hospitals
- combat_damage
---

# Damage

The damage commands are part of the FS3Combat system.

> Learn how the combat system works in the [Combat Tutorial](/help/fs3combat_tutorial).

`damage` - Views your damage. 
`damage <name>` - Views someone else's damage.

> **Note:** The healing progress bar on the damage display just shows how close you are to reducing the wound by one level. It may take several levels before you're fully healed.

## Treating

> **Note:** Treating only works soon after an injury, and only affects a single wound.  Inside combat, you use `combat/treat <name>` instead.

`treat <name>` - Treats someone's wounds with immediate first aid.

## Healing

> **Note:** Healing is more of ongoing care, like a nurse or doctor might give. You will continue healing someone until they are well. 

`heal/start <name>` - Takes someone as a patient.
`heal/stop <name>` - Removes a patient.
`heal/list` - Shows your patients.
`heal/scan` - Find injured patients who might need your services.

## Hospitals

When a room is marked as a hospital, people who are there heal faster.  

`hospitals` - Finds hospitals.

Admins or builders with the `build` permission can designate rooms as hospitals.

`hospital/on` or `hospital/off`- Makes the current room a hospital or not.

## Adjusting Damage

Admins and characters with the `manage_combat` permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<initial severity>/<current severity>/<IC date>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.