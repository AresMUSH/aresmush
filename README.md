AresMUSH
========

AresMUSH is a brand new MUSH server in development.  For more information see:  www.aresmush.com

***STATUS***:  Connect and create commands are done.

To play around with it:

# One Time Setup

* Get latest code.
* Make sure you have the necessary modules (listed in the gemspec, even though it's not a gem yet!)
* Edit the configuration files in game/config.
* Execute the Mongo database setup shown below.

# Mongo Setup

The first time you run mongo, you'll need to set up the authentication.  This is not currently automated.

1. Edit the mongo.conf file in the root directory to set auth = false
2. Run 'rake dbstart' to start the database.
3. Connect to the database using mongo localhost:7210  (use your host/port)
4. Execute the following commands to add the necessary users (passwords are obviously just examples, but the ares password must match databse.yml).

> use admin
> db.addUser("admin","admin")
> use aresmush
> db.addUser("ares", "bluebloods2")
> db.auth("ares", "bluebloods2")

5. Stop the server.
6. Edit the mongo.conf file again to change auth = true
7. Run 'rake dbstart' to start the database.
8. Run 'rake install' to install the default data.

Your database is now ready to go.

# Starting the Server

* Run 'rake dbstart' to start the database.
* Run 'rake start' to start the server.

# Playing

* Telnet to the server/port you specified in server.yml
* Type 'create YourName YourPassword' to create a character.
* Type 'quit' to quit.
* Connect again, and type 'connect YourName YourPassword' to connect back to your character.