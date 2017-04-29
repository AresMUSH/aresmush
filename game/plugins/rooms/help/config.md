---
toc: ~admin~ Configuring the Plugins
summary: Configuring the rooms system.
---
# Configuring the Rooms System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Rooms plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_rooms.yml`

## Interior Lock Cleanup Cron Job

The game will periodically unlock empty interior rooms that have been temporarily locked.  It does not affect rooms that have a permanent role lock.

There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/configuring-cron) for help if you want to change this or turn it off.
