---
toc: Managing Code
summary: Configuring AresCentral.
---
# AresCentral - Configuration

> **Permission Required:** Configuring the game requires the Admin role.

To configure the AresCentral plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_arescentral.yml`

## Games Directory

The game will automatically register itself with AresCentral the first time it starts up, using the game info you specified during installation.  You can update this info at any time using the Web Portal.  Go to the Portal's admin screen and select 'Game Info'.

## Directory Update Cron Job

The game will periodically contact AresCentral to update its status and game directory info.  There is a [Cron Job](http://www.aresmush.com/tutorials/configuring-cron) to control when this happens.  By default it does this daily during off-hours.

## AresCentral URL

This is the URL for contacting AresCentral.  You shouldn't ever have to change it unless for some reason AresCentral moves.

## Security

It's worth noting that each game is assigned a unique API Key, which is like a password used to secure communications between the game and AresCentral.  If you ever believe your API Key might have been compromised, you can get help at [aresmush.com](http://aresmush.com/feedback).
