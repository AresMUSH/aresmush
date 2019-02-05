---
toc: Tracking Time
summary: Using timezones and viewing server time.
aliases:
- ooctime
- timezone
---
# Time

Ares will display all dates and times according to your local timezone.  If you have a player handle, your timezone is managed in AresCentral.  See [Handles](/help/handles).  Otherwise you can change it at any time using:

`timezone <name>` - Sets your timezone.

Timezone names come from the world standard [timezone database](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones). Just enter the name - for instance, "Pacific/Fiji".   Ares also recognizes some of the common abbreviations (EST, CST, MST, PST, GMT, AST) and tries to map them to the closest available timezone option.  EST for example maps to "America/New_York".

The `time` command shows you a few bits of time-related information, including your local time.  You can compare this to your wall clock to make sure your timezone is set correctly.