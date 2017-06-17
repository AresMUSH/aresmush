---
toc: ~config~ Configuring the Plugins
summary: Configuring the scenes system.
---
# Configuring the Scenes System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Scenes plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_scenes.yml`

## Scene Set Cleanup Cron Job

The game will periodically clear scene sets from empty rooms.  

This does not affect scenes themselves (which may span multiple days and need to remain even when empty), just the room scene sets (which are usually for short-lived events).  

There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this or turn it off.
