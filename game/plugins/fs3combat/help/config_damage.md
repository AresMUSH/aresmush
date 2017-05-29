---
toc: Configuring FS3 Combat
summary: Configuring FS3 combat damage.
---
# Configuring FS3 Combat - Damage

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 damage system:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3combat_damage.yml`

## Wound Modifiers

You can configure the wound modifiers for each damage level to make combat either more realistic (higher modifiers) or more Hollywood-ish (lower modifiers).  Fractional modifiers are allowed, so small wounds can add up.

For context, remember that -3 is a very significant modifier - it can take a Great person down to an Amateur level.

## Healing Points

You can configure the number of healing points required to lower a wound to make damage either more realistic (higher numbers, slower healing) or more Hollywood-ish (lower numbers, higher healing).

A character gets 1 healing point per day by default, and 2 if they're in a hospital, under a doctor's care, or make a healing roll.  So if you set the healing time for IMPAIR to 7, it means that the character will heal from Impaired down to Flesh Wound in 3-7 days.

## Healing Cron Job

You can configure when the healing code runs.  By default it runs daily after midnight.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this.