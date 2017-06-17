---
toc: ~admin~ Coding
summary: Customizing your game.
---
# Custom

> **Permission Required:** Configuring the game requires the Admin role.

The 'custom' plugin is special because it will not be affected by future Ares upgrades.  You can add new code and configuration options here without worrying about colliding with changes in the standard codebase.

## Game-Specific Configuration

To configure the Custom plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_custom.yml`

You can add whatever config options you want here.  A common thing to do is to add game-specific shortcuts.  For example, to create a shortcut where typing 'foo' executes the 'ooc' command, you could add this to the shortcuts list:

    custom:
        shortcuts:
            foo: ooc