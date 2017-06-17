---
toc: ~config~ Configuring the Plugins
summary: Configuring the login system.
aliases:
- siteban
- ban
- suspect
---
# Configuring the Login System

> **Permission Required:** Configuring the game requires the Admin role.

## Connect Screen

To configure the Connect Screen:

1. Go to the Web Portal's Admin screen.  
2. Select 'Connect Screen'.

The connect screen can contain all the usual MUSH formatting codes (including color!), but you don't need to put in \%r for linebreaks or \%b for spaces.  The game will respect what's in the file as it appears.

## Terms of Service

By default, the game will present a Terms of Service file to new users.  

> **Tip:** If your TOS is long, it's recommended that you just link to a wiki/web page rather than spamming new players with a giant wall of text.

To configure the Terms of Service:

1. Go to the Web Portal's Admin screen.  
2. Select 'Terms of Service'.

The TOS can contain all the usual MUSH formatting codes, but you don't need to put in \%r for linebreaks.  The game will respect what's in the file.

> **Tip:** If you ever make important changes to the terms of service, you probably want to force existing characters to read them again.  To do this, use the `tos/reset` command in-game.  Everyone will be forced to acknowledge the new terms of service the next time they log in.

To disable the terms of service, see below.

## Other Configuration

To configure the rest of the Login plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_login.yml`


### Allow Web Registration

By default, players can create characters from the web portal.  This assumes that you've got Recaptcha enabled to prevent bots, and that you're not being routinely trolled.   If you wish to lock this down, you can set `allow_web_registration` to 'false'.

### Disabling Terms of Service

You can disable the terms of service completely by setting `use_terms_of_service` to false.

### Suspects and Bans

You can register certain IPs or hostnames as "suspect" and you'll be alerted (via a job) when a new character is created from one of these sites.  Banned sites work similarly but they actually prevent the character from logging in at all.

Use `findsite <name>` to find a character's IP and host information.

> **Tip:** You can use part of a hostname - often only the last bit is meaningful - but be careful about making it too broad.  Blocking a generic verizon or comcast host could end up blocking an entire region of players. 

Here is an example:

    banned_sites:
        - 192.168.1.1
    suspect_sites:
        - abc123.verizon.net
        - def456.comcast.net

To remove a ban or suspect site, just remove it from the list.

### Trouble Job Category

You can also configure which job category is used when the system creates a job for a suspect or boot alert.  By default it's the MISC category.

### Guest Role

The system looks for characters with the role set in `guest_role` when finding a guest character.  If for some reason you change that role, you need to update this configuration option.