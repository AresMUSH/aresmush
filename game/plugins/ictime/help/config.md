---
toc: ~admin~ Configuring the Game
summary: Configuring IC Time.
---
# Configuring the IC Time System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the IC Time plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_ictime.yml`

## Time Offset

The IC time system follows RL time at a 1:1 ratio, but you can shift it by a number of years and days.

For example, assume it's currently 2017 in RL.

If you want a game set in 1817 with the date the same as the RL month, you could do:

    year_offset: -200
    day_offset: 0

June 1, 2017 would then become June 1, 1817.

If you wanted a game set in 2217 where it was 6 months ahead of RL, you could do:

    year_offset: 200
    day_offset: 180

June 1, 2017 would then become roughly Dec 1, 2217. 

> **Tip:** The exact day it shifts ahead to will vary due to months having different lengths.  Just keep adjusting the day offset until you get the starting date you want.  From there it will advance 1 IC day for every RL day that passes.