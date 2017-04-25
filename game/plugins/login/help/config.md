---
toc: ~admin~ Configuring the Plugins
summary: Configuring the login system.
---
# Configuring the Login System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Login plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_login.yml`

## Suspects

Ares does not support an outright siteban because these days people mostly use dynamic or shared IPs, making it hard to pinpoint a particular person's IP address.

Instead you can register certain IPs or hostnames as "suspect" and you'll be alerted (via a job) when a new character is created from one of these sites.  You can use part of a hostname - often only the last bit is meaningful.

Here is an example:

    suspect_sites:
        - 192.168.1.1
        - verizon.net  

You can also configure which job category is used when the system creates a job for a suspect alert.  By default it's the MISC category.

## Guest Role

The system looks for characters with the role set in `guest_role` when finding a guest character.  If for some reason you change that role, you need to update this configuration option.