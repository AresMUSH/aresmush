---
toc: FS3 Skills and Combat
summary: Damage and healing in combat.
aliases:
- medicine
- hospitals
- damage
- wounds
- firstaid
- heal
- treat
- revive
- reviving
- rally
- healing
---
#Healing and Damage

## Damage

`damage` - Views your damage.
`damage <name>` - Views someone else's damage.

The healing progress bar on the damage display shows how close you are to reducing the wound by one level.

## Treating

For first aid/treatment immediately after an injury, medics can use the treat command.  Each treatment affects only a single wound. Requires Medicine.

`combat/treat <name>` - In combat, treats someone's wounds with immediate first aid.
`treat <name>` - Treats someone's wounds with immediate first aid.

## Reviving
`combat/rally <name>` - Rally a knocked out person (without first aid).
`combat/hero` - Spends a luck point to un-KO yourself and receive a very small amount of healing, making that wound un-healable by others. This doesn't erase the damage, it just lets you soldier on in spite of it.


## Mundane Healing

For more longer-term healing, doctors can use the heal command. You will continue healing someone until they are well. Requires Medicine.

`heal/start <name>` - Takes someone as a patient.
`heal/stop <name>` - Removes a patient.
`heal/list` - Shows your patients.
`heal/scan` - Find injured patients who might need your services.

## Hospitals

When a room is marked as a hospital, people who are there heal faster.

`hospitals` - Finds hospitals.
`hospital/on` or `hospital/off`- Toggles whether the current room is a hospital.

## Adjusting Damage

Admins, combat organizers, and characters with the manage_combat permission can add or modify damage.

`damage/inflict <name>=<description>/<severity>` - Inflicts damage outside combat.
`damage/modify <name>/<damage #>=<description>/<initial severity>/<current severity>/<IC date>` - Modifies damage.
`damage/delete <name>/<damage #>` - Deletes damage.

`combat/unko` - Un-KO's someone who shouldn't have been. Use sparingly.
