---
toc: 2 - Communicating
summary: Asking for help from the admin.
---
# Requests

The [game administrators](/help/admin) run the game.  If you need immediate help, you can use the [page](/help/page) command to send a private message to any admin who's online and listed as on-duty.  Sometimes, though, you have a non-urgent request or nobody is online to help you.  In that case, you can use the Request system to submit a request to the admins.  

Requests are like support tickets in many web applications.  You can track the status of your request, see who it's assigned to, and converse with the admin handling your request.

`request <title>=<description>` - Submits a request
`requests` - Views your active requests
`requests/all` - Views all of your requests, even closed ones.  

`request <#>` - Views details of a request.
`request/respond <#>=<comment>` - Adds a comment to a request.

> **Tip:** You can see multiple pages with requests2, requests3, etc.  This works with switches too, like requests2/all, requests3/all, etc.

## Requests/Jobs and Mail

Job requests are preferred over mail as a means of communicating with the game admin.  The jobs system does not normally send you a mail message when your request is updated.  All activity is logged in the job itself.

However, sometimes you may want to CC people other than admin on request communication.  You can use the request mail command to respond to the job while also sending a mail.

`request/mail <#>=<recipient names>/<message>` - Respond to a job and also send mail. 