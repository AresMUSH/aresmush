---
toc: ~admin~ Configuring the Game
summary: Configuring the roles system.
---
# Configuring the Roles System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Roles plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_roles.yml`

## Starting Roles

You can configure the list of roles that everyone starts with.  By default, this is just the 'everyone' role.

## Restricted Roles

Restricted roles can only be assigned and removed by the master admin character (Headwiz). 

## Admin List Roles

You can list roles that show up on the admin list.  For example, if you wanted to have the admin list show Code Staff and App Staff separately, you could create/assign roles for those people and then configure the admin list like so:

    admin_list_roles:
        - code_staff
        - app_staff