---
toc: ~config~ Configuring FS3 Skills
summary: Configuring FS3 experience.
---
# Configuring FS3 - Experience

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 Skills List:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3skills.yml`

## Before You Start

You should read the article [Tweaking FS3](http://aresmush.com/fs3/fs3-3/tweaking-fs3/), which contains important information to help guide you in customizing your game.

> **Tip:** Given the way FS3 is set up, it's is easy to create a very frustrating system by tweaking the XP advancement.  Please read the guide's advice on Experience.

## XP Schedule and Base Award

The game will periodically award all approved/active characters XP.  By default this happens weekly on Saturday evenings.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this.

Each time the cron job runs, it will dole out the number of XP specified in **periodic\_xp**.

## XP Costs

XP in Third Edition works a little differently than you might be used to.  Instead of saving up a ton of XP and spending them all at once, you spend them a little bit at a time to represent improvement over time. 

Each time you spend XP, there is a 'cooldown' where you cannot spend XP again on that same skill.  This enforces a gradual improvement.  You can configure this cooldown in the **days_between\_learning** configuration option.

When you have spent the total number of XP needed for the new ability rating, your rating rises.  The first rating point (e.g. "Everyman" or "Interest") always costs 1XP and raises immediately.  You can configure how many XP are needed for subsequent levels.

> **Tip:** High skills take a long time to improve, but since you earn XP each week, you still have extra to spread around on other abilities while you're waiting.

Consider the following example configuration: 

        language:
            1: 4
            2: 12
        action:
            1: 1
            2: 2

Raising a Language from 1 (Beginner) to 2 (Conversational) costs 4 XP and going from 2 (Conversational) to 3 (Fluent) costs 12 XP.  Since you can only spend 1 XP on the skill each month because of the cooldown, it will take at least 4 months to become Conversational and 12 to become Fluent.

Raising an Action Skill in that example is much easier.  It takes only 1 XP to go from 1 (Everyman) to 2 (Amateur) and 2 XP to go from 2 (Amateur) to 3 (Fair).  After that, though, the costs go up rapidly.  

## XP Hoard

You can configure the maximum amount of XP that someone can save up.  The default gives people a little buffer in case they forget to spend their XP, but keeps them from raising a flurry of skills all at once.