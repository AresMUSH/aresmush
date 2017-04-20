---
toc: ~admin~ Configuring the Game
summary: Configuring the website.
---
# Configuring the Website

The website has a configuration file that is kept in the web code itself.  

## CSS Style

The custom stylesheet for the game website is located in `game/plugins/website/web/public/custom_style.css`.   You can customize your website style there.

It's also worth noting that the AresMUSH website uses the [Bootstrap](http://getbootstrap.com/) website layout system, so all standard Boostrap styles are available.   It also includes [FontAwesome](http://fontawesome.io/icons/) icons and [JQuery UI](https://jqueryui.com/) styles.

## Server Configuration

The website's server configuration (how it talks to your game) should be updated automatically whenever you change the game config.  However, it can still be useful to understand how it works.

In the `game/plugins/website/web/public` directory is a file named `config.js`.  This javascript file contains the configuration information that the web client uses to talk to your game.

    var config = {
        port: '4202',
        mu_name: 'AresMUSH',
        host: 'localhost'
    }

The port name and host must match the websocket_port and hostname from your server configuration.   The MUSH name should match the MU name from your game configuration.