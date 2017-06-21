---
toc: ~config~ Configuring FS3 Combat
summary: Configuring FS3 NPC skills.
---
# Configuring FS3 Combat - NPC Skills

> **Permission Required:** Configuring the game requires the Admin role.

You can configure the skill levels used by NPCs in FS3 combat.

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat_npcs.yml`

FS3 has three NPC types: Goon, Henchman and Boss.  The simplest configuration is just to assign each of them a die rating:

    npc_types:
        Goon:
            Default: 4
        Henchman:
            Default: 6
        Boss:
            Default: 8

However, you can also fine-tune their specific skills.  This is helpful if you want to make a Boss tough to take down without making them extraordinarily deadly (or vice-versa).

    npc_types:
        Goon:
            Default: 4
            Firearms: 6
            Gunnery: 6
            Piloting: 4
        Henchman:
            Default: 6
            Firearms: 8
            Gunnery: 8

Any skills not expressly listed will use the 'Default' value.