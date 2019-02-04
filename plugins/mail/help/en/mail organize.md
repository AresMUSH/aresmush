---
toc: 2 - Communicating
summary: Organizing your mail.
---
# Organizing Mail

Instead of folders, Ares mail uses `tags`, which are a sort of label used to organize your mail.  There are several special tags:  

    Inbox - Incoming mail.
    Sent - If you've enabled the sent-mail feature, saves a copy of mail you've sent.
    Trash - Mail you've marked for deletion.
    Archive - Mail you've archived to keep it from cluttering up the inbox.

You can make your own custom tags as well to organize your messages as you desire.

`mail/tag <#>=<tag>` - Assigns a tag to a message.
`mail/untag <#>=<tag>` - Removes a tag from a message.
`mail/tags` - Lists all your tags.

You can filter your mail view to only show a certain tag.

`mail/filter <tag>` - Shows mail matching the tag.  Remains in effect until you 
        switch the filter or log out.
`mail/inbox, mail/sent, mail/archive or mail/trash` - Shortcuts to common tag views.

## Backing Up Mail

You can back up your mail to a log file.

`mail/backup` - Prints out your mail, which you can save to a log file.
