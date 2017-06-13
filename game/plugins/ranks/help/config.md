---
toc: ~config~ Configuring the Plugins
summary: Configuring the ranks system.
---
# Configuring the Ranks System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Ranks plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_ranks.yml`

## Rank Group

The ranks system is designed so that one group setting controls what ranks are available to you.  The default configuration bases ranks on Faction, so each faction will have a different rank system.

## Available Ranks

You list the ranks for each faction in order of seniority (least senior to most senior), along with a true/false indicator of whether that rank is available in chargen or not.  Restricted ranks must be set by admins or people with the manage_rank permission.

You can define different types within a faction - typically this would be for Officer/Enlisted ranks.  Types are just used for display purposes in the ranks list, and have no functional use.

        Navy:
            Officer:
                Ensign: true
                Lieutenant JG: true
                ...
                Admiral: false
                
            Enlisted:
                Crewman Recruit: true
                Crewman Apprentice: true
                ...
                Chief Petty Officer: false

## Ranks Template

The default template for the ranks display (`military_ranks.erb`) shows a side-by-side listing of Officer and Enlisted ranks, suitable for a military game.

If your game is different, there's also a more generic ranks template (`ranks.erb`).  You will have to modify the code to use that template, or simply use it as inspiration for modifying the standard template.