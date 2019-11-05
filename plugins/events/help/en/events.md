---
toc: Community
summary: Scheduling game events.
---
# Events Commands

The events system is an in-game calendar that lets you schedule events.

> Learn how the events system works in the [Events Tutorial](/help/events_tutorial).

## Viewing Events

`events`  - Lists upcoming events
`event <#>` - Views an event

## Creating and Deleting Events

> **Note:** When creating and editing events, times must be specified in the **server's** timezone.  This will be automatically converted to local time for anyone who has their timezone set.

`event/create <title>=<date and time>/<description>` - Creates an event. Use the game's configured date/time format.  The default  format is 2/1/2019 6:54pm.
`event/edit <#>` - Grabs the current event into your edit buffer (see help edit)
`event/update <#>=<title>/<date and time>/<description>`
`event/delete <#>`

## Signing Up For Events

`event/signup <#>=<comment>` - Sign up for an event.  If already signed up, this command can be used to change your comment.
`event/cancel <#>` - Removes your signup.
`event/cancel <#>=<name>` - Removes someone's signup (organizers only)

