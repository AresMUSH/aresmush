---
toc: ~admin~ Building
summary: Setting the weather.
---
# Weather

The current IC weather for your area shows up in room descriptions, but you can see the weather across the grid using the weather command.

`weather` - Shows the weather everywhere.

## Changing the Weather

> **Required Permissions:** This command requires the Admin role or the manage_weather permission.

You can manually override the weather.  This will take effect until the next automatic weather change.  You can also force the weather to change to something new in all areas with a weather reset.

`weather/set <area>=<temperature>/<weather condition>` - Sets a specific weather.
`weather/reset` - Updates weather in all areas.