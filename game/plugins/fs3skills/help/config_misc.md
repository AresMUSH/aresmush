---
toc: Configuring FS3
summary: Configuring FS3 luck and miscellaneous.
---
# Configuring FS3 - Luck and Miscellaneous

> **Permission Required:** Configuring the game requires the Admin role.

To configure the FS3 Skills List:

1. Go to the Web Portal's Admin screen.
2. Select 'Advanced Configuration'.
3. Edit `config_fs3skills.yml`

## Roll Channel

FS3 can optionally output rolls to a channel in addition to the room where the roll is made.  This can help staff call for rolls from afar.  You can remove the channel configuration if you don't want rolls going to it.

## Max Luck Points

You can configure the maximum number of Luck Points a character can save up at any one time.

## Public Sheet Pages

The default character sheet has only a single page, which is public (meaning any player can view it using the sheet command).

    public_pages:
        - 1

If you want sheets to be private, just make that setting empty:

    public_pages: []

If you change the code to add more sheet pages, you can list the ones you want to be public.  Any page not listed will be private.  For instance, you could make abilities public but have a second character sheet page for secret goals.

    public_pages:
        - 1
        - 2

> **Tip:** Private pages may only be viewed by the character himself or by someone with the `view_sheets` permission.