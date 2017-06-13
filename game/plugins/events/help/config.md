---
toc: ~config~ Configuring the Plugins
summary: Configuring the events system.
---
# Configuring the Events System

> **Permission Required:** Configuring the game requires the Admin role.

AresMUSH is designed to use the [Teamup](http://www.teamup.com/) event calendar system.  This offers several benefits over a traditional in-game system.  Players can view events on the web and even download an app to receive mobile notifications.  Event times are automatically translated into the player's local time, based on their timezone preferences.

If you prefer an in-game events system, there's a sample available at the [AresMUSH Code Repo](http://aresmush.com/code).

## Setting up a Calendar

To create a Teamup calendar:

1. Go to [teamup.com](http://www.teamup.com/) and sign up for an account.
2. Click "Create a Free Calendar."
3. Enter the information and click "Create".  The Basic(free) plan is sufficient.

Congratulations - you now have a Teamup calendar.  You will receive a link to a URL like:  `https://teamup.com/abc12345`.  This URL gives you admin access to your calendar.  Keep it in a safe place.

## Permissions

It's important to know that Teamup does not use different user accounts.  On the up side, this means your players don't need to sign up for accounts.  Using Teamup is fast and easy.

The down side is that anyone with access to the URL has access to your calendar.  Teamup provides different URLs with different permissions.  You can find these URLs under the Sharing settings:

1. Go to the admin access URL.  
2. Click the little blue menu bars on the right to open the settings menu.
3. Select "Settings".
4. Go to "Sharing".

There are a variety of URLs with different permission levels.  

* If you share the read-only URL, all events would have to be scheduled by the admins (presumably via a +request in-game).  
* If you share the "Add Events" URL, players could create new events but not change them; that would have to be done by the admin.
* If you share the "Modifier" URL, players could create and modify events.  Since there are no users, there is no concept of event ownership.  Anyone can edit anyone else's events.

You choose which URL to share with your players.

## Configuring Ares to Talk to the Calendar

Now you need to set up Ares to talk to your calendar.  You'll need two pieces of data from Teamup: 

* API Key
* Calendar ID

### Finding Your Calendar ID

Use the steps listed in *Permissions* above to find the calendar URL you want to share with your players.  It will look like:  `https://teamup.com/xyz7890433`.  The jumble of letters and numbers at the end of the URL is your calendar ID.

> **Tip:** Do not use the admin calendar ID from the URL you received via email; this will give all your players admin access to your calendar.

### Get Your API Key

Fill out the [Teamup form](https://teamup.com/api-keys/request) to request your API Key.  This is like a password that lets your game talk to the Teamup server.  The key will be emailed to you.

### Configure the Game

To configure the game to talk to your calendar:

1. Go to the Web Portal's Admin screen.  
2. Select 'Secret Codes'.
3. Scroll down to 'Teamup Events'.
4. Enter the API Key and Calendar ID
5. Click Save.

## Other Settings

To change the other Events plugin configuration:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_events.yml`

### Calendar Timezone

You can change your calendar's timezone on the Teamup website by visiting the admin URL and selecting Settings -> Date and Time -> Timezone.  You need to also then tell Ares what that timezone is.  The default is EST.

### Events Refresh Cron Job

The game will periodically get the latest events from the calendar.  There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this.

You can also manually refresh the events at any time by typing `events/refresh` in game.