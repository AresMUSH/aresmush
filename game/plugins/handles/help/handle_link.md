---
topic: handle link
toc: 
summary: 
categories:
- main
---
To create a Handle, go to AresCentral (http://aresmush.com/arescentral/) and create a character there using the name you want for your Handle name.

Having a handle is only useful once you `link` characters to it.  This tells the game which characters on which games are yours.  Linking is optional; you can pick and choose which characters you want to link.  Linking is a multi-step process to verify your identity on both AresCentral and the local game.  This prevents someone from linking characters to your handle without your permission.

1) Using the character you want to link, find your character ID.

`handle/id`

2) On AresCentral, use the character ID from step 1 to generate a one-time use link code specific to that character.

`handle/linkcode <character id>`  (AresCentral only)
    
3) Back on the original game, use your one-time link code from step 2 to link the character to your handle.

`handle/link <handle name>=<link code>`

You can find out information about your handle and characters linked to it using the info command.  On AresCentral, you can unlink a character from your handle:

`handle/info`
`handle/unlink <character id>`  (AresCentral only)
