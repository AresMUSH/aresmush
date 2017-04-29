---
toc: ~admin~ Configuring the Plugins
summary: Configuring character generation.
---
# Configuring the Chargen System

> **Permission Required:** Configuring the game requires the Admin role.

To configure the Chargen plugin:

1. Go to the Web Portal's Admin screen.  
2. Select Advanced Config.
3. Edit `config_chargen.yml`

## App Messages

You can configure the messages that are put into the approval job when characters are approved or rejected.  Commonly you will edit the approval message to tell new players your game's wiki password or anything special they need to know to get started.

`approval` - This message is sent when they're approved.
`rejection` - This message is sent when they're rejected.

The system will also create a job *after* someone is approved, to remind the game admin to do any ancillary tasks, like adding them to lists, or creating a wiki page or a log icon.  You can configure the todo list in the job message.

`post_approval` - This message is put in the admin job after someone's approved.

Finally, the system will automatically post a message to the BBS system when a character is approved.  You can configure what this message says.  %{name} and %{position} are parameters passed to the message representing the character's name and position.  You can place them wherever you want in the string.

`welcome` - This message is posted to the welcome board when someone is approved.

You can also configure which BBS board the welcome message is posted to.

`arrivals_board` - Where to post the welcome message.

## Job Configuration

If you've changed your Jobs plugin configuration from the default, you may need to edit the categories and states that the chargen system uses.

* app_category - Character applications use this category.
* app\_resubmit_status - When an app is re-submitted, the job enters this state.
* app\_hold_status - When an app is rejected, the job enters this state.

## Chargen Stages

Character creation is done as a series of 'stages'.  For each stage, you can choose to display either a help file, a tutorial file, or both.

> **Tip:** Tutorial files are stored in the `chargen/templates` directory.

For example, the first stage in the sample configuration below will show the 'chargen.md' tutorial file and the second stage will show the 'sheet' help file.

    stages:
        start:
            tutorial: 'chargen.md'
        sheet:
            help: 'sheet'
