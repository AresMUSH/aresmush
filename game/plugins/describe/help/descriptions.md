---
topic: descriptions
toc: Building
summary: Descriptions.
categories:
- builder
aliases:
- desc
- describe
- shortdesc
- detail
---
---
topic: descriptions
toc: Descriptions
summary: Looking around.
categories:
- main
aliases:
- desc
- describe
- look
- shortdesc
---
Every character, room and exit has a description that tells you what you see when you look at it.

`describe <name>=<description>`
`describe/edit <name>` - Grabs the existing description into your input 
       buffer (if your client supports it.  See `help edit`.)
       
You can set a shorter description that is used whenever an at-a-glance description is needed.

`shortdesc <name>=<description>`
`shortdesc/edit <name>` - Grabs the existing description into your input 
       buffer (if your client supports it.  See `help edit`.)

You can also have multiple outfits for your character, and have more detailed views that are separate from your main description.  See:

    `help outfits`
    `help details`

The `look` command is used to look around.

`look <name>`
`look`  (shortcut for looking at 'here')
`look <name>/<detail>` - Looks at a detail on something.
