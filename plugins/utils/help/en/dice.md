---
toc: Utilities / Miscellaneous
summary: Rolling random dice.
aliases:
- coinflip
- coin
- die
---
# Dice Roller

The dice command is used to roll random dice.  The syntax is `<numDice>d<dieSides>`.  

For example: 4d6 would roll four six-sided dice.

Note: The dice command just shows you the raw results, e.g., [ 4, 3 ].  Interpreting the results, adding modifiers, etc. is all up to you. Being generic like this supports all variety of dice systems (roll + sum, roll + count successes, etc.)  You just tell it how many dice to roll.

A coin flip can be simulated using 1d2 with a result of '1' meaning heads and '2' meaning tails.

`dice <die string>` - Rolls dice and shows the results to your room.
`dice/private <die string` - Rolls dice but only shows the results to yourself.