---
toc: 2 - Communicating
summary: Asking for help from the admin.
---
# Requests Commands

Requests are like support tickets in many web applications.  You can use them when you need assistance from the game admin. Requests are part of the "jobs" system used for tracking staff jobs/tasks. So sometimes you may see 'job' instead of 'request' in command text.

> Get an overview of the request system in the [Request and Jobs Tutorial](/help/jobs_tutorial).

## Creating and Viewing Requests

`request <title>=<description>` - Submits a request
`requests` - Views your active requests
`requests/all` - Views all of your requests, even closed ones.  
`request <#>` - Views details of a request.

> **Tip:** You can see multiple pages with requests2, requests3, etc.  This works with switches too, like requests2/all, requests3/all, etc.

You can add multiple participants to a single request.  They will be able to see and comment on the request as if it were their own.

`request/addparticipant <#>=<name>` - Adds another player to a request.  
`request/removeparticipant <#>=<name>` - Removes a player from the request.

## Responding to Requests

`request/respond <#>=<comment>` - Adds a comment to a request.
`request/mail <#>=<recipient names>/<message>` - Respond to a request and also send mail. 

> **Tip:** Requests are preferred over mail as a means of communicating with the game admin.  The request system does not normally send you a mail message when your request is updated.  All activity is logged in the request itself.