---
toc: ~admin~ Coding
summary: Executing arbitrary Ruby code.
---
# Ruby

> **Permission Required:** These commands require the Coder role.

The ruby command lets you execute arbitrary Ruby code from your MU client.  You can't create new commands this way, like you can with MUSHcode, but you can do little utility tasks.

`ruby <code>` - Evaluates Ruby code.

You can use raw Ruby code, just as you would in a code file.  Separate multiple lines with semicolons.

For example: 

    ruby c = Character.find_one_by_name("Faraday");c.update_demographic("hair","blonde")

> Note: Allowing someone to execute raw Ruby code is basically giving them the keys to the kingdom (and database), which is why this command is locked-down to people with the Coder role.  Be careful who you give coder privileges.
