---
toc: Jobs
summary: Managing jobs.
---
# Managing Jobs

> **Permissions Requred:** Working with jobs requires the access_jobs permission.

The basic workflow for jobs goes like this:

* Someone creates a job.  State => NEW
* An admin handles or assigns a job.  State => OPEN
* An admin adds comments to a job.  Other admins or the submitter can reply.  Job comments can be admin-only or visible to the submitter.  A job can be placed on HOLD if it's waiting for something.
* An admin closes the job.  State => DONE

## Creating Jobs

Jobs can be created by players using the `request` command, by coded systems (e.g. apps), or manually.

`job/create <category>=<title>/<description>` - Creates a new job
        Default categories are APP (Applications), BUILD (Building), CODE, MISC, RP and REQ (Request).

## Changing Job Status

You can change various attributes about the job, including its status and who it's assigned to.

`job/assign <#>=<player>`                  `job/handle <#>` 
`job/status <#>=<status>`                  `job/cat <#>=<category>` 
`job/title <#>=<title>`   
        Default status values are NEW, OPEN, HOLD (job on hold) and DONE.

## Adding Job Comments

There are two ways for admins to comment upon a job.  A `discuss` comment is for admin eyes only, and will never be seen by the original submitter.  A `respond` comment is **viewable by the submitter**.

`job/discuss <#>=<comment>` - Comments on a job (only admins may view)
`job/respond <#>=<message>` - Comments on a job (admins and submitter may view)
`job/deletereply <#>=<reply#>` - Deletes a reply.

Players can automatically see responses on their own requests; there's no need to send them mail.  But if you want to send a mail related to a job that wasn't their own request, you can use the `job/mail` command to add a comment to the job and send that comment in a mail message.

`job/mail <#>=<recipients>/<message>` - Sets a response (admins and submitter may view) on the job and sends that response in mail to the recipients.

## Closing Jobs

When you're done with the job, close it and it will be archived.

`job/close <#>` - Closes a job
`job/close <#>=<message>` - Closes a job with a comment to the original submitter.
