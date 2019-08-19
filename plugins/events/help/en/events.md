---
toc: Utilities / Miscellaneous
summary: Scheduling game events.
---
# Events

The events system is an in-game calendar that lets you schedule events.

`events`  - Lists upcoming events
`event <#>` - Views an event

Events are color coded based on how close they are.

* Green = within 24 hours
* Yellow = within 48 hours
* Bold = within 7 days

## Creating and Deleting Events

You can create and edit your own events.  Characters with the `manage_events` permission can edit other peoples' events too.

Note: When creating and editing events, times must be specified in the **server's** timezone.  This will be automatically converted to local time for anyone who has their timezone set.

`event/create <title>=<date and time>/<description>` - Creates an event. Default date format is 2/1/2019 6:54pm.
`event/edit <#>` - Grabs the current event into your edit buffer (see help edit)
`event/update <#>=<title>/<date and time>/<description>`
`event/delete <#>`

## Signing Up For Events

`event/signup <#>=<comment>` - Sign up for an event.  If already signed up, this command can be used to change your comment.
`event/cancel <#>` - Removes your signup.
`event/cancel <#>=<name>` - Removes someone's signup (organizers only)
