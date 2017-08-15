---
toc: ~admin~ Managing the Game
summary: Managing character applications.
---
# Managing Applications

> **Permission Required:** These commands require the Admin role or the permission: manage\_apps

The application review process goes as follows:

* The player does `app/submit` to submit their character.  This creates an approval job.
* App staff does `app/review` to review the character's background and abilities.
* App staff can either `app/approve` or `app/reject` the character.  The approval job is automatically updated and either closed (if approved) or placed on hold (if rejected).
* If rejected, the player makes the necessary revisions and then does `app/submit` again.  The approval job is re-opened.

There's a single approval job throughout the process, making it easier to keep track of the status and revisions, and to make it clear who's handling a character.

## Reviewing Characters and Backgrounds

Application managers can quickly review the character's background, sheet, profile and description.

`app <name>` - Reviews someone's application, showing any chargen errors or warnings.
`app/review <name>` - Quick command to review app, background, profile and sheet all at once.

## Approving and Rejecting a Character

Once you've reviewed a character, you can approve or reject their application.

`app/approve <name>` - Approves a character.
`app/reject <name>=<message>` - Rejects a character and unlocks them so they can make changes.


## Editing Backgrounds

Application managers can view and edit other character backgrounds, in case you need to make simple tweaks during the approval process.

`bg/set <name>=<background>` - Sets a background.
`bg/edit <name>` - Grabs the existing background text into your input buffer.
`bg <name>` - Views someone else's background.

## Unapproving a Character

If you ever make a mistake and accidentally approve someone, you can unapprove them.

`app/unapprove <name>` - Unapproves someone.

