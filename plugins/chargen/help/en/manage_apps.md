---
toc: ~admin~ Managing the Game
summary: Managing character applications.
aliases:
- manage_applications
- unapprove
- approve
- reject
---
# Managing Applications

**These commands require the Admin role or the permission: manage\_apps**

## Reviewing & Proccessing Applications
Character apps can also be reviewed online by choosing 'Review' from the job menu in the appropriate job.

`app <name>` - Reviews someone's application, showing any chargen errors or warnings.
`app/review <name>` - Quick command to review app, background, profile and sheet all at once.

`app/approve <name>` - Approves a character.
`app/reject <name>=<message>` - Rejects a character and unlocks them so they can make changes.

The approval job is automatically updated and either closed (if approved) or placed on hold (if rejected).

`app/unapprove <name>` - Unapproves a character who has been approved.omeone.

## Editing Backgrounds
App Staff can view and edit other character backgrounds, in case you need to make simple tweaks during the approval process.

`bg/set <name>=<background>` - Sets a background.
`bg/edit <name>` - Grabs the existing background text into your input buffer.
`bg <name>` - Views someone else's background.
