---
toc: FS3 Combat
summary: Combat damage and healing.
aliases:
- damage
- treat
- heal
- healing
- hospitals
---
This is a quick reference for the combat damage commands. For more details on FS3, see `help combat`.
 
`damage` - Views your damage. 
`damage <name>` - Views someone else's damage.

Note that the healing progress bar on the damage display just shows how close you are to reducing the wound by one level. 

For first aid/treatment immediately after an injury, medics can use the treat command.  Each treatment affects only a single wound.  Inside combat, you use `combat/treat <name>` instead.

`treat <name>` - Treats someone's wounds with immediate first aid.

For more longer-term healing, doctors/healers can use the heal command.  You will continue healing someone until they are well.  

`heal/start <name>` - Takes someone as a patient.
`heal/start <name>` - Removes a patient.
`heal/list` - Shows your patients.

When a room is marked as a hospital, people who are there heal faster.

`hospitals` - Finds hospitals.