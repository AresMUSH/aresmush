---
toc: ~admin~ Coding
summary: Using server-side version control.
---
# Git

> **Permission Required:** These commands require the Coder role.

The "git" command is used to access the server's version control commands.  See the aresmush.com tutorial on [Using GitHub](https://aresmush.com/tutorials/code/git.html) for more information about how this works.

`git <command>` - Issues a git command to the server.  

> Note: Only a handful of git commands are actually supported, because there's no way to do interactivity (like prompting for passwords or merge actions).

Supported commands include:  

    git commit -m <message>
    git add <filespec>
    git pull
    git status
    git diff

`git/load` - Shortcut for a `git pull` followed by a `load all`.
