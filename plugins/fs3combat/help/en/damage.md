---
<<<<<<< HEAD
toc: 5 - Magic, FS3 Skills, and Combat
=======
toc: FS3 Skills and Combat
>>>>>>> upstream/master
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

<<<<<<< HEAD
`damage` - Views your damage.
=======
`damage` - Views your damage. 
>>>>>>> upstream/master
`damage <name>` - Views someone else's damage.

> **Note:** The healing progress bar on the damage display just shows how close you are to reducing the wound by one level. It may take several levels before you're fully healed.

## Treating

> **Note:** Treating only works soon after an injury, and only affects a single wound.  Inside combat, you use `combat/treat <name>` instead.

`treat <name>` - Treats someone's wounds with immediate first aid.

## Healing

<<<<<<< HEAD
> **Note:** Healing is more of ongoing care, like a nurse or doctor might give. You will continue healing someone until they are well.
=======
> **Note:** Healing is more of ongoing care, like a nurse or doctor might give. You will continue healing someone until they are well. 
>>>>>>> upstream/master

`heal/start <name>` - Takes someone as a patient.
`heal/stop <name>` - Removes a patient.
`heal/list` - Shows your patients.
`heal/scan` - Find injured patients who might need your services.

## Adjusting Damage

Admins and characters with the `manage_combat` permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<initial severity>/<current severity>/<IC date>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.