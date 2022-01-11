---
toc: Community
summary: Dealing with harassment and abuse.
tutorial: true
title: Dealing with Harassment and Abuse
aliases:
- trouble
- harassment
- harassing
- harass
- abuse
- trouble
- harassed
- troll
- trolling
---
# Dealing with Harassment and Abuse

Unfortunately, you will sometimes have troublesome players who are trolling, harassing, or otherwise abusing you or other players.  There are a variety of commands for players and admin to deal with them.

[[toc]]

## Player Commands

### Booting Trolls

If someone is causing a ruckus, you can forcibly disconnect them using the `boot` command.

Normally this would be done by game admin, but the default Ares configuration allows all approved characters to use the boot command.  This helps players protect each other even when an admin is not available. All uses of the boot command are logged and require the player to specify the reason.

### Reporting Channel Abuse

You can report abusive channel conversations using the `channel/report` command or the "Report Abuse" menu option in the web portal chat screen.  This will create an admin job with the channel recall buffer automatically included.

### Monitoring and Reporting Harassing Pages

You can report abusive PM/page conversations using the `page/report` command or the "Report Abuse" menu option in the web portal chat screen.  This will create an admin job with the conversation automatically included.

### Reporting Offensive Mails

You can report abusive mail messages using the `mail/fwd` command or the "Forward" button in the web portal mail screen.

### Reporting Offensive Scene Behavior

You can report abusive scene behavior using the `scene/report` command or the "Report Abuse" menu option in the web portal scene screen.  This will create an admin job with the scene log automatically included.

## Admin Commands

### Booting Trolls

Admins can forcibly disconnect characters using the `boot` command. 

### Turning Trolls into Statues

The `statue` command, similar to Rhost's FUBAR flag or MUX's @toad, can deter trolls whose goal is to be sitebanned.   When you turn a player into a statue, they will be unable to use any commands at all - not even to quit. 

### Unapproving Trolls

Most game-altering commands (building, posting to forums, starting scenes) are locked to approved characters by default.  This inherently protects you against malicious guests and characters fresh off the login screen.  If an already-approved character causes mischief, you can unapprove them using `app/unapprove` to deny them access to these commands.  

### Banning Trolls

Banning a site doesn't target a particular character, but a particular IP or hostname.  It prevents ANY characters from logging in, being created, or accessing the web portal from that site.  Be aware that this could potentially block _other_ players logging in from the same ISP.

Use the `ban` command to ban characters.

### Blacklisting Proxy Sites

_Developed with assistance from Ashen Shugar@RhostMUSH._

If someone is using a proxy server, banning them can be like playing whack-a-mole as they keep switching IPs.  An extreme measure is to ban all known proxy sites.  This can make things more difficult for a troll, but at a risk of blocking users who are running a proxy server for legitimate reasons.  We recommend not enabling this feature unless you're having serious trouble with a proxy troll.

To ban proxy sites, simply enable the option in the [Web Portal banned/suspect sites configuration](/tutorials/config/sites.html)

Game admin and approved characters can connect from a proxy site, even if the proxy blacklist is enabled. If you need to ban someone who's admin/approved, be sure to unapprove or remove their admin privileges first.

> **Note:** There are thousands of proxy IPs on the Internet, and the list is constantly changing.  Blocking them all is impossible, but blocking some can sometimes be better than nothing.

### Setting Suspects

Suspect sites are ones that aren't banned, but you want to be alerted (via staff job) if anyone new comes from that site.  You might use this if someone is on probation and you want to know if they try to create a new alt.

In the [Web Portal banned/suspect sites configuration](http://aresmush.com/tutorials/config/sites.html), you can designate specific IP addresses and/or hostnames as suspect sites.

> **Note:** Setting a site suspect does not enact any special logging, unlike the SUSPECT flag in other MU servers.

### Monitoring Trolls

General commands appear in the [game log](http://aresmush.com/tutorials/code/logs.html), but private conversations (pages, poses, mail and channels) are not.  Players have tools to report page and channel harassment, as explained in the *Player Commands* section above.

Ares does not have a 'SUSPECT' flag in the way you might be used to from other MU* servers.  It is often used for malicious purposes and rarely for good.