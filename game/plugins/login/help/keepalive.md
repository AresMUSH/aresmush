---
toc: Misc
summary: Keeping your connection alive.
categories:
- main
---
Some routers get fussy if you don't do something on the connection periodically.  You can have your client periodically send a command that does absolutely nothing but will keep the connection alive.

`keepalive` or `@@`

In addition, AresMUSH automatically sends a message to your client periodically to keep the connection open from the other direction.  You can turn this off.

`keepalive <on or off>`