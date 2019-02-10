---
toc: ~admin~ Managing the Game
summary: Admin work assignments.
aliases:
- ticket
---
# Jobs

The Jobs system is used by the game administrators to track work requests and to-do items.  Players can submit their own requests.

> **Permissions Requred:** Working with jobs requires the access_jobs permission.

> Note:  Some games will have multiple staff roles with limited access to certain categories.  For example - builders may only be able to access the 'BUILD' category.  You can still create jobs in other categories, but they are treated as _requests_ (see [Requests](/help/request)).

## Viewing  Jobs

The jobs list shows you the jobs.

`jobs` - Lists jobs
`job <#>` - Views a job.

You can mark jobs as read with the catchup command:

`jobs/catchup` - Marks all jobs as read.
`jobs/catchup <number>` - Mark a specific job as read.

## Filtering  Jobs

You can change what jobs you see in the jobs list.  If you're a coder, you could set your filter to only show jobs in the CODE category.  Or you might set the filter so it only shows jobs that are assigned to you.

> **Tip:** Your job filter is remembered when you log out.

Valid filters are:

* Active - Jobs that are active (not done or on hold) and/or have new activity since you last looked.  This is the default filter.
* Mine - Active jobs assigned to you.
* Unfinished - All jobs not marked done.
* (Category Name) - Active jobs in the given category.
* All - All jobs.

`jobs/filer <flter>` - Filters the jobs list.
`jobs/mine`, `jobs/active`, `jobs/all` - Shortcuts for the common filters.

## Creating Jobs

Jobs can be created by players using the `request` command, by coded systems (e.g. apps), or manually.

`job/create <title>` - Creates a new job (REQ category)
`job/create <category>=<title>/<description>` - Creates a new job
        Default categories are APP (Applications), BUILD (Building), CODE, MISC, RP and REQ (Request).
`job/query <player>=<title>/<description>` - Submit a request on behalf of someone.

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

## Jobs and Mail

Players can automatically see responses on their own requests; there's no need to send them mail.  If you want to send a mail related to a job that wasn't their own request, you can use the `job/mail` command to add a comment to the job and send that comment in a mail message.

`job/mail <#>=<recipients>/<message>` - Sets a response (admins and submitter may view) on the job and sends that response in mail to the recipients.
  
Admins can convert a mail message into a job.

`mail/job <#>` - Turns a mail message into a job request.

## Closing Jobs

When you're done with the job, close it and it will be archived.

`job/close <#>` - Closes a job
`job/close <#>=<message>` - Closes a job with a comment to the original submitter.

## Old  Jobs

For help finding old jobs, see [Jobs Archive](/help/jobs_archive).