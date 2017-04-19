---
toc: Managing Code
summary: Configuring channels.
---
# Configuring the Channel System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the AresCentral plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_channels.yml`

## Start and End Markers

You can configure the characters that appears at the beginning and end of the channel name.  This lets you alter the appearance to do things like:

    <Chat> Faraday says, "This is MUSH style."
    [Chat] Faraday says, "This is MUX style."

Start and end markers can include ansi color and other formatting codes.

## Default Channels

You can configure which channels new characters join by default when they are first created.  This should be a list.  For example:

    default_channels:
        - Questions
        - Chat