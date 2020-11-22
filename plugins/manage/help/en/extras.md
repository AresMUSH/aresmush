---
toc: ~admin~ Coding
summary: Adding new plugins.
aliases:
- install
---
# Installing Extras

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

## Plugins

Several plugins are available in the [Ares Extras](https://aresmush.com/tutorials/code/extras.html) repository, including officially-supported extensions and community contributions.  You can install them directly from the game:

`plugin/install <github url>`
  
> **Note:!** Many plugins require some additional manual install steps.  Be sure to check the README file in each plugin's folder for detailed information on installation and configuration.

## Themes

Different themes for your web portal are also available in [Ares Extras](https://aresmush.com/tutorials/code/extras.html). You can install one from the game:

`theme/install <github url>` - Installs a theme
`theme/install default` - Restores the default theme.
  
> **Note:!** This will replace your current theme and theme images (if images are provided).  Your old theme files are backed up to the `aresmush/theme_archive` directory in case you need to get them back (manually).