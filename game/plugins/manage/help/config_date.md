---
toc: ~admin~ Configuring the Game
summary: Configuring the date and time formats.
---
# Configuring the Date and Time Formats

> **Permission Required:** Configuring the game requires the Admin role.

To configure the date and time preferencse:

1. Go to the Web Portal's Admin screen.  
2. Select 'Date/Time Formats'.

The game shows dates and times in various places.  You can configure how these are shown.  You have complete control over each format.  You can change the it use hyphens, put the month first or second, use two-digit years instead of four-digit years, use 12 or 24-hour time, etc.  

> **Tip:** For full details of the available options, see the [Ruby Date/Time Format Documentation](https://apidock.com/ruby/DateTime/strftime).

* Short Date Format - This is used when you just want a short date, like 1/2/2016.  
* Long Date Format - This combines date and time into a longer format, like 27 March 2016, 5:45pm.
* Time Format - This is just the time by itself, like 5:45pm.

The 'date entry format help' configuration item is a little special.  It is not a code-oriented format string.  Rather, it is intended to be read by humans to tell them what format to enter birthdays and other dates.