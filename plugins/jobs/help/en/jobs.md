---
toc: ~admin~ Managing the Game
summary: Admin work assignments.
aliases:
- ticket
---
# Jobs

The Jobs system is used by the game administrators to track work requests and to-do items.  Players can submit their own requests with the [request](/help/requests) command.

> Get an overview of the the jobs system in the [Jobs and Requests Tutorial](/help/jobs_tutorial).

## Viewing  and Filtering Jobs

`jobs` - Lists jobs
`job <#>` - Views a job.

`jobs/filter <flter>` - Filters the jobs list. Valid filters are: active, mine, unfinished, unassigned, unread, all, or a specific category name.
`jobs/mine`, `jobs/active`, `jobs/all` - Shortcuts for the common filters.
`jobs/subscribe` and `jobs/unsubscribe` - Subscribes to new job notices, so you'll get a personal notification for any new job.

> **Tip:** Your job filter is remembered when you log out.

## Creating Jobs

`job/create <title>` - Creates a new job (in default category, usually REQ).
`job/create <title>=<category>/<description>` - Creates a new job. Default categories are APP (Applications), BUILD (Building), CODE, MISC, RP and REQ (Request).

`job/query <player>=<title>/<description>` - Submit a request on behalf of someone.
`job/addparticipant <#>=<name>` - Adds a participant to a job.
`job/removeparticipant <#>=<name>` - Removes a participant from a job.

> **Tip:** All participants will be able to see and comment upon the job as if it were their own request.

## Changing Job Status

`job/handle <#>` - Assign a job to yourself.
`job/assign <#>=<player>` - Assign a job to someone else.
`job/status <#>=<status>` - Change job status.
`job/cat <#>=<category>` - Change job category.
`job/title <#>=<title>` - Change job title.

`jobs/catchup` - Marks all jobs as read.
`jobs/catchup <number>` - Mark a specific job as read.

## Adding Job Comments

`job/discuss <#>=<comment>` - Comments on a job (only admins may view; will never be seen by the submitter)
`job/respond <#>=<message>` - Comments on a job (viewable by submitter)
`job/deletereply <#>=<reply#>` - Deletes a reply.

## Jobs and Mail

`job/mail <#>=<recipients>/<message>` - Sets a response (admins and submitter may view) on the job and sends that response in mail to the recipients.
`mail/job <#>` - Turns a mail message into a job request.

> **Tip:** Players can automatically see responses on their own requests; there's normally no need to send them mail.

## Closing Jobs

`job/close <#>` - Closes a job and archives it.
`job/close <#>=<message>` - Closes a job with a comment to the original submitter.

## Old  Jobs

`jobs/search <category>=<value>` - Searches old jobs. Category to search may be 'title' or 'submitter'.

`jobs/backup` - Prints out closed jobs to the screen, so you can save them to a log file.
`jobs/purge` - Deletes all closed jobs.  Be cautious with this, since there's no going back.
`job/delete <#>` - Deletes a particular job.