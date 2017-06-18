---
toc: ~config~ Configuring the Game
summary: Backing up the game.
alias:
- dbbackup
---
# Backing Up the Game

> **Permission Required:** Performing backups requires the Admin role and (in some cases) access to the server shell.

It's important to make backups of your game database and code.  There are several ways to back up your game, so you can choose the one that works best for you.  See the AresMUSH.com tutorial [Backing Up The Game](http://aresmush.com/tutorials/manage/backups) for more information.

## S3 Backups

If you choose to do automatic AWS backups to an S3 bucket, here are the instructions to configure the game so it can talk to AWS.

1. Go to the Web Portal's Admin screen.  
2. Select Secret Codes.
3. Scroll down to 'AWS'.

You'll need your AWS access key, bucket name and the code for the region your bucket is in.  You can find the AWS region codes [here](http://docs.aws.amazon.com/general/latest/gr/rande.html#apigateway_region).

> **Important:** Even if you use S3 for other things, create a separate bucket just for your AresMUSH backups.  Ares will delete older files to make room for new backups, and you don't want it to accidentally delete anything important!

### Other Backup Preferences

1. Go to the Web Portal's Admin screen.  
2. Select 'Advanced Config'.
3. Select `config_manage.yml`.

You can configure the number of backups the game keeps.  By default this is 5.  Older backups are automatically deleted.

You can also configure when backups are done.  By default it's early morning, after peak MU* times.  See the [Cron Job Tutorial](http://www.aresmush.com/tutorials/code/configuring-cron) for help if you want to change this.

### Database File Path

If you performed a custom installation, you may also need to configure a different path for where the database dump file lives.  

1. Go to the Web Portal's Admin screen.  
2. Select 'Advanced Config'.
3. Select `database.yml`.
4. Enter the path to redis' dump file.

### Test the Backup

There are many moving parts in the backup process.  Once you have it all set up, we recommend that you test it once using the manual `dbbackup` command.  Make sure that the database file ends up in your S3 bucket successfully before relying on the automatic daily backups.