---
toc: Code Management
summary: Custom code snippets
categories:
- admin
---
The tinker command can be used to run custom code snippets.  For example, let's say you really quickly wanted to find all the characters whose names start with "G".  There's no admin command for that, but you can whip up a quick tinker for it.

It's like a PennMUSH coder trying to do something ad-hoc like:

    think iter(lsearch(all,type,player), DO SOMETHING)

Same idea, but the code lives on the server side.

1. Edit tinker_cmd.rb and put the custom code into the handle method. For example:

    c = Character.all.select { |c| c.name.start_with?("G") }.map { |c| c.name }
    client.emit c.to_s

2. `load manage` to reload the code.
3. `tinker <your command syntax>` to tinker.

