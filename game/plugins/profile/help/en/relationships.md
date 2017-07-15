---
toc: Community
summary: Tracking IC relationships.
---
# Tracking IC Relationships

The relationships command lets you keep track of IC relationships your character has.  You can provide a category for each relationship, like "Acquaintances", "Friends", etc.   You can also track relationships with NPCs too - just make sure their name doesn't overlap with a PC name.

> **Note:** All relationships are public and can be seen by anyone.  Please don't get bent out of shape if someone has an unflattering or inaccurate opinion of your character.  It's just IC.

`relationship/add <name>=<category>/<details.` - Adds or updates a relationship.
`relationships[ <name>]` - Sees relationships (yours or someone else's).

This is for IC relationships between characters.  For OOC relationships, see the [Friends](/help/friends) command.

## Editing Relationships

You can update a relationship using the same 'add' command that created it in the first place.  You can also delete a relationship or move it to a new category (without changing the actual details).

`relationship/delete <name>` - Deletes a relationship.
`relationship/move <name>=<new category>` - Moves a relationship to a new category.

## Ordering Relationships

You can't put individual relationships in any order, but you can order the categories.

`relationships/order <list of categories separated by commas>`