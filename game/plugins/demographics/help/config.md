---
toc: ~admin~ Configuring the Game
summary: Configuring demographics.
---
# Configuring the Demographics Plugin

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Demographics plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_demographics.yml`

## Age Limits

You can enforce minimum and maximum age limits in chargen with the `min_age` and `min_age` values.

If you don't want a limit, just set them to 0 and 99 respectively.

## Demographics

You are able to specify all of the demographics you're going to use.  

> **Tip:** Use all-lowercase names!  These are going to be converted into code variables, and lowercase is important.
 
### Required Properties

Any demographics you list in `required_properties` are mandatory in chargen.  

> **Tip:** The names here must exactly match the names in the demographics list.

### Editable Properties

Any demographics you list in `editable_properties` may be changed after chargen.  You want to allow mutable things like hair color to change, but probably not birthdate or eye color.

> **Tip:** The names here must exactly match the names in the demographics list.

## Groups

The groups list is where you set up your game's groups.  Each group has a description and a list of possible values.  Each value has a name and a description.

If you omit the values, the group will be freeform, allowing the player to specify any value they want.  This is commonly used for Position if you don't have a fixed list of available positions.

    groups:
        Faction:
            desc: "Military faction."
            values:
                Navy: "Join the fleet, see the worlds."
                Marines: "Semper fi."



