---
toc: AresCentral
summary: Configuring AresCentral.
---
# AresCentral - Configuration

This article details how game admins can configure AresCentral.

## Games Directory

The game will automatically register itself with AresCentral the first time it starts up, using the game info you specified during installation.  You can update this info at any time using the Web Portal's "Game Setup" screen.

Each game is assigned a unique API Key, which is like a password used to secure communications between the game and AresCentral.

## Cron

You can set up a [Cron Job](http://www.aresmush.com/tutorials/configuring-cron) for when the game will contact AresCentral to report itself as being 'up' and sync up any game info changes.  By default it does this daily during off-hours, which should be sufficent for all games.

## AresCentral URL

This is the URL for contacting AresCentral.  You shouldn't ever have to change it unless for some reason AresCentral moves.