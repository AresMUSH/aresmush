---
toc: Pathfinder 2e
order: 5
summary: Purse, Society account, and coin transfers.
aliases:
- coins
- wealth
- society_account
---
# PF2e - Money

> Overview: [Pathfinder 2e](/help/pf2e).

Coin is tracked by denomination: **pp, gp, sp, cp**.

* **Purse** — on your person. Counts toward Bulk (1000 coins = 1 Bulk) when encumbrance is enabled.
* **Society account** — Hall ledger in your name. Not physical coin; **not** Bulk. Shops charge the purse only.

`money` - Show purse and Society account.
`money/deposit <amount>` - Move coin from purse → Society account.
`money/withdraw <amount>` - Move coin from Society account → purse.
`money/optimize [<keep amount>]` - Rebreak the purse into fewest coins. Any value above the keep target is deposited to Society. With no amount, only rebreaks the current purse.

## Amount format

Combine denominations in one string:

    money/deposit 5gp
    money/withdraw 10sp 5cp
    money/deposit 1pp 2gp
    money/optimize 15gp

## Shopping

Vendors take **purse** only. Withdraw first if your funds are on the Society account. See [Shop](/help/shop).
