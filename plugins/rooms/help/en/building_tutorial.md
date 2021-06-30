---
toc: ~admin~ Building
summary: Building the grid.
tutorial: true
aliases:
- icstart
---

Scenes have to take place *somewhere*.   The Ares scene system lets you start scenes in temporary rooms, but the majority of MUSH players still prefer to have a **grid** - a tangible set of **rooms** linked by **exits** for them to explore and play in.  

> **Tip:** Despite the name, a Room doesn't have to represent a single room.  It's more like a virtual 'chatroom' - a place where people gather for roleplay.

[[toc]]

## Building Basics

Here are the basics of building the grid.  Building can only be done through the MU client at present, not the web portal:

1. Teleport to the IC Start location using `tel Onstage`.  This is the place where characters will first arrive on grid.  (See Special Rooms below for more details).
2. Rename the IC Start location to something more appropriate to your theme, like `name here=Main Gate`.
3. Describe the room.  `desc here=The main gate is big and spikey.`
4. Build your first new room, naming the exits going back and forth.  For example, `build Commons=N,S` will build the Commons north of the gate, with an exit going south.
5. Rinse and repeat, building more rooms connected by exits.

You can also make rooms that aren't connected to the main grid, but are still available for scenes.  Some games use this to define locations that are outside the main IC area, or in lieu of a traditional grid arrangement.  Just build the room without specifying any exits, and it'll just be hanging out in virtual space.

## IC Start Room

The first time a character goes onstage, they will start in the designated "IC Start Location".  By default this is the room named "Onstage", though most games will rename that to something appropriate to their theme--Downtown, Docking Bay, Town Square, etc.

At any time, you can change the IC starting location to a different room using the `icstart` command.  With custom code, it is possible to have players start in different IC starting locations depending on faction/homeworld/etc.  See [Custom IC Start Location](https://aresmush.com/tutorials/config/status.html).

## Finding Rooms and Exits

Most building commands will accept either a name (as long as it's unambiguous) or a database ID.  For example, you can either do:

    open N=Commons              (opens an exit named N to the commons)
    open N=Northbrook/Commons   (specifies the area in case you have multiple rooms named Commons)
    open N=#R-123               (opens an exit to room #123)

You can find rooms and exits using the `rooms` and `exits` commands in case you need to look up a database ID.

## Managing Exits

Normally you'll create exits automatically when you build, and won't have to worry about them after that.  However, there are a few special cases where you might want to add or modify exits.

### Creating and Re-Linking Exits

You can create additional exits using the 'open' command, and link exits to different rooms.  You can use the room database ID or a name (as long as the name is unambiguous).  See "Finding Rooms and Exits" above for more info on database IDs.

Once you have an exit, you can change the source or destination rooms that it's linked to using the `link` command.  Again, you can use either a name or database ID. 

### Naming Exits

By default, the room description shows you the exit name and the name of its destination.  For example:

    Exits:
    [M]   Maintenance Shed              [N]   Courtyard                     
    [SE]  Forest Road  

You'll want exit names to be 1-2 letters usually. Compass directions are popular (`N, S, E, W`) as is `O` for out or the first letter of the name (e.g. `C` for courtyard).

> **Tip:** You can configure what brackets are used for exits in the [Description Config](https://aresmush.com/tutorials/config/describe.html).

Most players get by without the usual  "N;north;nor" etc. exit aliases that were traditional in Penn/Tiny.  However, you can set a single exit alias if you really need one, using the `alias` command.

> **Tip:** Any exit named "O" is automatically aliased to "Out".  Also, if no specific 'out' exit exists, 'out' will simply take you out the first exit it can find.

## Exit and Room Descriptions

An exit can have a description (visible if you `look N` for example), but you can also use the `shortdesc` feature to change the destination name.  For example, if the exit normally shows `[SE] Forest Road` you can set a shortdesc to make it say `[SE] Dark Path`.

[Details](/help/details) let you set additional details in a room that someone can look at, like a sign, photo, or landmark.

[Vistas](/help/vistas) allow you to set up different pieces of the room description to be shown based on the time of day and season.

## Room Type

Each room in Ares has a type, which is one of:

* **IC** - The areas that are on-camera where the RP takes place.
* **OOC** - The backstage areas where people hang out and official business takes place.
* Roleplay Room (**RPR**) - Permanent rooms that are available for RP but not connected to the usual grid. These are mostly obsolete given the scene system, but some folks still feel more comfortable using them over scene temp rooms.

> **Tip:** A newly-built room will automatically inherit the room type of the room you were standing in when you used the `build` command.  So as long as you build from the IC start room, all your connected rooms will be IC.

The status system is based off the room type.  If you're in an OOC room, you're considered OOC.  If you're in an IC or RP room, you're considered IC.

## Areas

Areas let you organize rooms as a navigational aid and a way help identify where you are.  Typically they correspond to distinct geographic areas - districts in a city, decks on a ship, individual planets, etc.  Areas also help distinguish between rooms with the same name (i.e. a Mess Hall on one ship versus a Mess Hall on another ship).

You can use areas in custom code - e.g. making it so certain commands are only available (or work differently) depending on the area the character is in.  For example, the weather plugin determines weather patterns by the room areas.

> **Tip:** Although there will probably be multiple IC areas on your grid, you'll usually have only one OOC area.  In the default database, it's just called "Offstage".

### Creating Areas

Areas are automatically created when you assign an area to a room using `area/set` as explained in the [Building](/help/building) commands.  You can also manually create them using `area/create`.  Areas can be edited and deleted from the web portal as well.

### Area Descriptions

Areas can have a description (in which you might want to put some ASCII map art or a link to a map image).

> Note: If you want to include an ASCII map, include it in 'pre' tags to make it format correctly.  For example:  

    [[pre]]
    ^^--->>>
    [[/pre]]

### Area Hierarchy

You can set up areas in a parent/child hierarchy.  For example:

* Chicago
  * The Loop
  * Northbrook
* New York
  * Brooklyn
  * The Bronx
* Offstage

## Special Rooms

Ares has several special rooms, which are part of the default database.  They each serve an important purpose in the code, so you can't destroy them.  You can change their names and descriptions, though.

* **Welcome Room** - Where characters first arrive on the game.  Typically you'll update this room description with a description of the game and some basic instructions.
* **Offstage** - Where characters go when they use the `offstage` command to take a break from roleplay.  AKA the "OOC Room" or "OOC Lounge".
* **Quiet Room** - Where characters can idle without being bothered by spam.  Poses/emits don't work here and arrival/departure messages are silenced.


## Locks

Ares has a simpler exit lock system than PennMUSH/TinyMUX.  You cannot lock exits to any arbitrary code function.  Exits may only be locked to [roles](https://aresmush.com/tutorials/manage/roles.html). 

For example: If you wanted to lock the Rebel HQ to only players in the rebel faction, you could create a "Rebel" role and assign it to everyone with rebel access.  Then lock the HQ entrance to only people with the "Rebel" or "Admin" roles.

## Room Owners

By default, only people with builder privileges can modify the description on a room.  However, builders can assign 'owners' to a room, who are also allowed to describe it.  This is done using the `owners` command.

## Foyers

Marking a room as a foyer using the `foyer` command is useful for RP Room hubs and apartment buildings.  It just makes numbered exits appear in a separate section, with an indication of whether they're in use or not.

    Exits:
    [O]   Parking Lot
    ------------------------------------------------------------------------------
              [1] Bob's Apartment (Occupied)        [2] Faraday's Apartment (Locked)    

## Grid Coordinates

Grid coordinates can help people navigate the grid.  You can use whatever coordinate system you want - for example letters or numbers (1,1) or (B,2).  Coordinates don't really do anything other than show up in the room descriptions for reference.

## Command Reference

[Building Commands](/help/building)
[Areas](/help/areas)

[[disableWikiExtensions]]