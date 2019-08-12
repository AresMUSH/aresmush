---
toc: ~admin~ Managing the Game
summary: Admin work assignments.
aliases:
- ticket
---
# Jobs

The Jobs system is used by the game administrators to track work requests and to-do items.  Players can submit their own requests with the [request](/help/requests) command.

> **Permissions Requred:** Working with jobs requires the access_jobs permission.  Some games will have multiple staff roles with limited access to certain categories.  For example - builders may only be able to access the 'BUILD' category.

For a general overview of using jobs, see the aresmush.com [Jobs tutorial](https://aresmush.com/tutorials/manage/jobs.html).

## Viewing  Jobs

The jobs list shows you the jobs.  You can also just see a quick summary of unread ones, which you may want to put into your [onconnect](/help/onconnect).

`jobs` - Lists jobs
`job <#>` - Views a job.
`jobs/all` - Shows all jobs, even old ones.  Add a number after 'all' to see additional pages (e.g. jobs/all2, jobs/all3, etc.)

`jobs/catchup` - Marks all jobs as read.
`jobs/catchup <number>` - Mark a specific job as read.

## Filtering  Jobs
`jobs/filter <fliter>` - Filters the jobs list.
`jobs/mine`, `jobs/active` - Shortcuts for the common filters.

Valid filters are: active, mine, unfinished, unread, all, or a specific category name

## Creating Jobs

Jobs can be created by players using the `request` command, by coded systems (e.g. apps), or manually.

`job/create <title>` - Creates a new job (REQ category)
`job/create <title>=<category>/<description>` - Creates a new job
        Default categories are APP (Applications), BUILD (Building), CODE, MISC, RP and REQ (Request).
`job/query <player>=<title>/<description>` - Submit a request on behalf of someone.

## Multi-Character Jobs

You can add multiple participants to a single job.  All participants will be able to see and comment upon the job.

`job/addparticipant <#>=<name>`
`job/removeparticipant <#>=<name>`

## Changing Job Status

`job/assign <#>=<player>`
`job/handle <#>`
`job/cat <#>=<category>`
`job/status <#>=<status>`
`job/title <#>=<title>`
        Status values are NEW, OPEN, HOLD (job on hold) and DONE.

## Adding Job Comments
`job/discuss <#>=<comment>` - Comments on a job (only admins may view)
`job/respond <#>=<message>` - Comments on a job (admins and submitter may view)
`job/deletereply <#>=<reply#>` - Deletes a reply.

`job/mail <#>=<recipients>/<message>` - Sets a response (admins and submitter may view) on the job and sends that response in mail to the recipients.

Admins can convert a mail message into a job.

`mail/job <#>` - Turns a mail message into a job request.

## Closing Jobs
`job/close <#>` - Closes a job
`job/close <#>=<message>` - Closes a job with a comment to the original submitter.

## Old  Jobs

For help finding old jobs, see [Jobs Archive](/help/jobs_archive).
