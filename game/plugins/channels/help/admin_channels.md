---
topic: channels
toc: Game Management
summary: Managing channels.
categories:
- admin
aliases:
- channel
- chat
- comsys
plugin: channels
---
The channel administration commands are used to create, delete, and describe channels.

`channel/create <channel>`
`channel/delete <channel>`
`channel/describe <channel>=<description>`
`channel/color <channel>=<ansi prefix>` - Sets a channel's color.
        Use full ansi code(s) not just the color name.  For example: \%xc
        You can use multiple codes.  For example:  \%xh\%xr
`channel/roles <channel>=<roles>`
        Use "none" to clear existing roles.  
        Changing roles will remove anyone who is on the channel but doesn't 
        have the appropriate roles.
`channel/defaultalias <channel>=<aliases>` - Sets the default aliases to use when
        joining a channel.  Alias can be a list of comma-separated names.  For example, for 
        chat you might use c,ch,cha.  
