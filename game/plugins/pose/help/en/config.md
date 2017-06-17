---
toc: ~config~ Configuring the Plugins
summary: Configuring the pose system.
---
# Configuring the Pose System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Pose plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_pose.yml`

## OOC Color

You can configure the color that is used in OOC asides. You can use multiple color codes.  For example: \%xh\%xc

## Repose System

You can enable or disable the repose system globally.

## Repose Cleanup Cron Job

The game will periodically clear out the repose system for empty rooms.  There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this.