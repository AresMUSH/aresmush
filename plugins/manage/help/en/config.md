---
toc: ~admin~ Coding
summary: Managing the game configuration.
tutorial: true
aliases:
- cron
---
# Managing Config

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

AresMUSH is ready to go out of the box with a default configuration based on a Battlestar Galactica setting. Most games will want to customize Ares to their own theme and preferences.

For configuration tutorials, see [AresMUSH.com](https://aresmush.com/tutorials/config/).

**Tip:** For best results, make configuration changes through the web portal Admin screen.

## View Configuration

The easiest way to view the game's configuration is on the web portal.  You can also see it in-game by section or by a specific variable.

`config` - Lists config sections
`config <section>` - Views config variables for a section.
`config <section>/<variable>` - Views a specific config variable.
  
## Loading Config Changes

If you change config through the web portal, the game will automatically load the new config.  If you change config files on disk, you'll need to load the configuration manually.

`load config` - Reloads configuration from disk.

## Checking for Config Errors

If you're getting weird configuration errors and are having trouble figuring out where the problem lies, you can run a complete check of your game config.

`config/check`

If one of your config files is messed up, you can restore it to the defaults using:

`config/restore <file>` (e.g. config/restore website.yml)

## Viewing Cron Jobs

You can also get a summary of what cron jobs have been configured.  Note: This will find all of the standard Ares cron jobs.  If you have added custom code, make sure your cron config settings have the word "cron" in their name.

`config/cron`