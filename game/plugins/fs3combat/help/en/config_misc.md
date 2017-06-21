---
toc: ~config~ Configuring FS3 Combat
summary: Configuring miscellaneous FS3 Combat options.
---
# Configuring FS3 Combat - Miscellaneous

> **Permission Required:** Configuring the game requires the Admin role.

This topic describes some miscellaneous combat options you can configure.

## Lethality Tuning

To tune how lethal combat is overall:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat.yml` 

There are two settings you can adjust:

1. `pc_knockout_bonus` - Number of dice added to PC knockout rolls.
2. `npc_lethality_mod` - A modifier added to all NPC damage to make it more lethal.

By default, these values are skewed so that PCs are harder to knock out and NPCs take more damage overall.