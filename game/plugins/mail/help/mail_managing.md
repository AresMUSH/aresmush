You can delete mail messages.  Technically this doesn't delete it right away, but tags it as trash.  Messages tagged as trash are deleted when you log out.

`mail/delete <#> or <start#>-<end#>` - Sends a message to the trash.
`mail/undelete <#>` - Recovers a message from the trash.
`mail/emptytrash` - Permanently deletes messages in the trash.

Instead of deleting a mail message, you can archive it.  See %xhhelp mail tags%xn.

`mail/archive <#>` - Clears current tags and applies the Archive tag instead.

You may want to backup your mail before deleting it.

`mail/backup` - Prints out your mail, which you can save to a log file.