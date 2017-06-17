---
toc: ~config~ Configuring the Plugins
summary: Configuring the status system.
---
# Configuring the Status System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Status plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_status.yml`

## Idle Timers

You can configure how long someone must be idle before they are automatically considered AFK and how long someone must be idle before they are automatically disconnected from the game. 

You can disable either or both of these timers by commenting out or removing the line from the configuration file.

## Status Colors

You can configure which colors are used to display different status values in the who list and other systems.  For example, the following configuration uses red for IC and highlighted blue for OOC.

    colors:
        IC: "\%xr"
        OOC: "\%xh\%xb"

## AFK Cron Job

The game will periodically check for idle players and mark them AFK automatically.  There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this or turn it off.



