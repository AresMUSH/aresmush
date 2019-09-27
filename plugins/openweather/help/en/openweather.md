---
toc: 4 - Writing the Story
summary: Using Openweather
---
# Openweather

The current IC weather for your area shows up in room descriptions, but you can see the weather across the grid using the weather command.

`openweather` - Shows the weather everywhere.

Openweather is similar to the standard AresMUSH weather command, but uses
real life weather data for areas. It talks to the openweather.org API

## Changing the Weather

> **Required Permissions:** This command requires the Admin role or the manage_weather permission.

Openweather areas are configured in the openweather.yml file. The weather
in the area updates every hour. If you want to force the update use
the following command

`openweather/reset` - Updates weather in all areas.