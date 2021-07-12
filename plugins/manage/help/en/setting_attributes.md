---
toc: ~admin~ Coding
summary: Setting attributes.
aliases:
- set
- '&'
---
# Setting Attributes

In old-school MU servers, you could directly set any player attribute just by doing:

    &something *bob=whatever

You don't do that in Ares because the database is more complex. Data fields may be multi-tiered hash values, references to other objects, or have limitations that can cause errors if you put in wrong values.

Instead, you will use dedicated admin commands to change player data.  Want to change their demographic info?  There's a command for that. Their abilities? There's a command for that too. And so on. Many fields can also be edited on the web portal via the character's profile page. 

> You can find admin commands in the 'Admin' section of the [help page](/help) in topics like [Managing Demographics](/help/manage_demographics). They generally have 'manage' in their names like `help manage channels` or `help manage demographics`.

As a last resort, you can use the [tinker](/help/tinker) or [ruby](/help/ruby) commands to manually execute database updates. **Be careful** - you can mess up your data or cause errors this way.

    ruby Character.named("Bob").update(something: 'whatever')