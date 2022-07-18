---
toc: ~admin~ Managing the Game
summary: Managing character applications.
---
# Managing Applications

> **Permission Required:** These commands require the Admin role or the permission: manage\_apps

## Application Workflow

Here's the general workflow for the chargen system.

* The player completes chargen and submits their character.  This creates an approval job.
* App staff reviews the character's background and abilities.
* App staff can either approve or reject the character.  The approval job is automatically updated and either closed (if approved) or placed on hold (if rejected).
* If rejected, the player makes the necessary revisions and then submits again.  The approval job is re-opened and the process repeats as many times as necessary.

There's a single approval job throughout the process, making it easier to keep track of the status and revisions, and to make it clear who's handling a character.

All of this can be done either through the web portal or through in-game app commands.

## App Review

A key feature that allows Ares chargen to remain generic is that characters are not *prevented* from doing things in chargen, they're only **warned** about it on the app review screen.

For example, the game will not stop them from taking a skill too high or set a weird combination of faction/job, but it will *warn* them if they've done so.  They can then tweak that or submit a justification for why they've done something unusual.

Admins see the same app review screen that the players do.  If it's all "green"/OK, then you know that the character has everything set within the allowable limits.  If there are yellow warnings or red errors, you know that there is a potential issue with the character.  You can even add your own [custom checks](https://aresmush.com/tutorials/config/chargen.html) with a little code, thus making app review a very quick and painless process.

## After Approval

When a character is approved, they will get a message (that you configure) telling them their next steps.  They will be allowed to go onstage to the IC areas, and will have access to the forums and other approved-only commands.

## Command Reference

`app <name>` - Reviews someone's application, showing any chargen errors or warnings.
`app/review <name>` - Quick command to review app, background, profile and sheet all at once.
`app/approve <name>` - Approves a character.
`app/reject <name>=<message>` - Rejects a character and unlocks them so they can make changes.

Application managers can view and edit other character backgrounds, in case you need to make simple tweaks during the approval process.

`bg/set <name>=<background>` - Sets a background.
`bg/edit <name>` - Grabs the existing background text into your input buffer.
`bg <name>` - Views someone else's background.

If you ever make a mistake and accidentally approve someone, you can unapprove them.

`app/unapprove <name>` - Unapproves someone.

