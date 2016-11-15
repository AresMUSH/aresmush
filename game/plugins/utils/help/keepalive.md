---
topic: keepalive
toc: Misc
summary: Keeping your connection alive.
categories:
- main
plugin: utils
---
Some routers get fussy if you don't do something on the connection periodically.  You can have your client periodically send a command that does absolutely nothing but will keep the connection alive.

`keepalive` or `@@`