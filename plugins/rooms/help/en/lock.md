---
toc: Utilities / Miscellaneous
summary: Locking exits.
aliases:
- lock
---
# Locking Exits

If you're in an interior room (defined as one with an "O" out exit), you can lock and unlock the outside door (i.e. the one leading INTO the room from the outside) for privacy.

`lock`
`unlock`

These locks are temporary.  The game periodically clears the locks on empty rooms.

## Permanent Locks

> **Permissions Required:** This command requires the Admin role or the 'build' permission.

Builders can also lock exits to a list of roles - for instance if you had a "rebel" role you could lock a secret rebel exit to "rebel admin" so only rebels and admins could use it.  Role locks are not limited to interior rooms; any exit can be locked.

`lock <exit>=<list of roles who are allowed in>`
`unlock <exit>`