# Death



## Overview

This plugin creates 'death' in FS3 combat. PCs who are KO'd have 3 rounds to be treated, rallied, to combat/hero, or to be otherwise revived before they 'bleed out'. A warning emits at the end of every turn during which a character remains KO'd.

This does not work for NPCs, as NPCs are removed from combat on KO.

## Installation

**WARNING**: This is NOT a plug and play plugin. It requires inserting a few bits of code into core FS3, as outlined below. They're simple inserts that should be clear if there's ever a merge conflict, but they do raise the possibility of them.

1. In the game, run `plugin/install URL`.
2. In `combat_hero_cmd.rb`, add `Death.zero(combatant)` after `combatant.update(is_ko: false)`
3. In `combat_unko_cmd.rb`, add `Death.zero(combatant))` after `combatant.update(is_ko: false)`
4. In `actions_helper.rb`, inside `def self.check_for_ko`, add `Death.one(combatant)` after `if (roll <= 0)`
5. In `damage_helper.rb`, inside `def self.treat` replace `t('fs3combat.treat_success', :healer => healer_name, :patient => patient_name)` with `Death.treat_dying(healer_name, patient_char_or_npc)`
6. In FS3's `custom_hooks.rb`, in `def.self_custom_new_turn_reset`, add `Death.new_turn(combatant)`


## Configuration

There is no configuration for this plugin.

## Web Portal

This plugin has no web portal code.  

## Credits
Tat @ Ares Central
