---
toc: ~config~ Configuring the Plugins
summary: Configuring the places system.
---
# Configuring the Places System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Places plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_places.yml`

## Same Place Color

You can configure the color that highlights the place name when something happens in your place. You can use multiple color codes.  For example: \%xh\%xc

## Places Cleanup Cron Job

The game will periodically clear out empty places from rooms.  There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this.