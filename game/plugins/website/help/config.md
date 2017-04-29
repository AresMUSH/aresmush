---
toc: ~admin~ Configuring the Plugins
summary: Configuring the website.
aliases:
- css
- recaptcha
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

## Configuring Recaptca

The game website uses Google's [Recaptcha](https://www.google.com/recaptcha/intro/) to keep bots from creating accounts.  Sign up for your own key by clicking "Get Recaptcha" from that website.

1. Create a new "Recaptcha v2" key.
2. List your game's website domain under the domains list.  You can also list 'localhost' if you're doing local testing.
3. Google will show your key info.

Under 'Client Side Integration' you'll find a code snippet like this:

`<div class="g-recaptcha" data-sitekey="ABCD123"></div>`

The 'ABCD123" is your Recaptcha Site.

Under 'Server Side Integraton' you'll see an entry like this:

`secret(required): DEFGH789`

The 'DEFGH789 is your Recaptcha Secret.

To configure the recaptcha information:

1. Go to the Web Portal.
2. Select 'Secret Codes'.
3. Scroll down to 'Recaptcha'.
4. Enter your secret and site ids.