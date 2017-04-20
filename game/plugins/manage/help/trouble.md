---
toc: ~admin~ Managing Game
summary: Dealing with troublesome players.
aliases:
- boot
- findsite
- ban
- siteban
- sitelock
---
# Dealing With Trouble

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

Unfortunately, you will sometimes have to deal with troublesome players.  These commands will help.

## Booting Characters

If someone is causing a ruckus or gets stuck online or something, you can disconnect them.

 `boot <name>` - Forcibly disconnects someone from the game.

## Findsite

The findsite command will help you find characters with similar IP address, which may be alts of one another.

> **Tip:**  Many internet providers use dynamic/block IP addresses, which means that some players who live geographically close to each other (including, obviously, roommates) may end up with the same host name or IP.

`findsite` - Shows a site summary identifying possible alts.
`findsite <name, host or IP>` - Shows someone's IP address and any similar ones.

## Suspect Sites

Ares does not support a 'siteban' feature because too many people these days share IP address blocks.  Your odds of banning innocent people is high.  Instead there is the ability to configure (server-side) a list of suspect hosts or IP addresses.  This is done in the [Login plugin](/help/login/config) configuration.
