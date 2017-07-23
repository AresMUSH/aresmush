---
toc: Community
summary: Game events.
---
# Events

The events system is an in-game calendar that lets you schedule events.

`events`  - Lists upcoming events
`event <#>` - Views an event

You can create and edit your own events.  Characters with the `manage_events` permission can edit other peoples' events too.

`event/create <title>=<date>/<time>/<description>`
`event/edit <#>` - Grabs the current event into your edit buffer (see help edit)
`event/update <#>=<title>/<date>/<time>/<description>`
`event/delete <#>`

Events are color coded based on how close they are.

* Green = within 24 hours
* Yellow = within 48 hours
* Bold = within 7 days