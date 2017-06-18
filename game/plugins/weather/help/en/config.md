---
toc: ~config~ Configuring the Plugins
summary: Configuring the weather system.
---
# Configuring the Weather System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Weather plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_weather.yml`

## Weather Cron Job

The game will periodically change the weather.  There is a cron job to control when this happens.  By default it does this every hour.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this or turn it off.

## Temperatures and Conditions

These lists control what temperatures and weather conditions are available for your use.  Creating new ones requires a little bit of a code change, explained at the end of this article.

## Seasons

The weather system uses a simplistic calculation to determine season based on the month of IC Time.

* Dec-Feb: Winter
* Mar-May: Spring
* Jun-Aug: Summer
* Sep-Nov: Fall

If you want to make this more sophisticated (like accounting for different seasons on different planets, or months like November which are half winter and half fall), you'll have to change the code.

## Climates

The heart of the weather system is the climate configuration.  You can define different climates for different geographical areas - for example, a temperate climate for your regular areas and a polar climate for the snowy north.

Weather is driven by season, so you can make it colder in winter than in summer.  Of course, in the polar climate it may be cold all year round and in a tropical climate you might have a rainy season. 

Here is a brief snippet from the sample weather configuration:

        temperate:
            summer:
                temperature: hot hot hot hot hot warm warm warm cool cool
                condition:  clear clear clear fair fair fair drizzling drizzling overcast raining
                stability: 70
            spring:
                temperature: cool cool cool cool cool warm warm warm warm warm
                condition:  clear clear clear fair fair fair drizzling drizzling overcast raining
                stability: 70

The `temperature` line contains ten possible temperatures for that season.  There are ten entries by default, so each entry has a 10% chance of occurring.  In the example above, there are 5 instances of "hot" in summer, so there's a 50% chance of being hot (and also a 30% chance of being warm, and a 20% chance of being cool).

Similarly, the `condition` line contains ten possible weather conditions.  In summer there's a 30% chance of clear skies, 30% chance of fair weather, 20% chance of drizzling, 10% overcast, 10% raining.

> **Tip:** You are not limited to ten entries.  That's just convenient for understanding that each entry represents a 10% chance.  You could have 20 entries (5% chance each) or even 100 entries (1% chance each) to fine-tune the weather as much as you want.

Finally, the `stability` factor represents how likely the weather is to change on an hourly basis.  A stability rating of 70 means that there's a 70% chance of the weather staying the same, and a 30% chance of it changing each hour.

## Assigning Climates

The weather system lets you configure a climate for each room area.  You can use 'none' to disable the weather system for that area.  

For example, the following config will use the polar climate for the North area and disable weather in the offstage area.  Any other areas will use the temperate climate.

    climate_for_area:
        Offstage: none
        North: polar
        
    default_climate: temperate

To disable weather completely, you can just make the default_climate 'none'.

## Adding New Temperatures/Conditions

If you want temperatures and conditions beyond the default ones, you'll have to change the code - specifically, the weather translations file.

Each weather condition has a locale entry like so:

    en:
        weather:
            clear: "The skies are clear."
            fair: "The weather is fair."

Also, each combination of season, temperature and weather must have a locale entry like so:

    en:
        weather:
            hot_spring_morning: It is a hot spring morning.
            hot_spring_day: It is a hot spring day.

For more information on how locale files work, see the [Locales Tutorial](http://aresmush.com/tutorials/locale) on aresmush.com.