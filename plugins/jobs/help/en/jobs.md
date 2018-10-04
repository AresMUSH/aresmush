---
toc: ~admin~ Managing the Game
summary: Admin work assignments.
aliases:
- ticket
---
# Jobs

The Jobs system is used by the game administrators to track work requests and to-do items.  Players can submit their own requests.

> **Working with jobs requires the access_jobs permission.**
> Note:  Some games will have multiple staff roles with limited access to certain categories.  For example - builders may only be able to access the 'BUILD' category.  You can still create jobs in other categories, but they are treated as _requests_ (see [Requests](/help/request)).

## Viewing Jobs
`jobs` - Lists jobs
`job <#>` - Views a job.
`jobs/all` - Shows all jobs, even old ones.  Add a number after 'all' to see additional pages (e.g. jobs/all2, jobs/all3, etc.)

`jobs/catchup` - Marks all jobs as read.
`jobs/catchup <number>` - Mark a specific job as read.

## Filtering  Jobs
`jobs/filter <fliter>` - Filters the jobs list.
`jobs/mine`, `jobs/active` - Shortcuts for the common filters.

Valid filters are:
* Active - Jobs that are open and/or have new activity since you last looked.  This is the default filter.
* Mine - Jobs that are open and assigned to you.
* (Category Name) - Jobs in the given category.

## Creating Jobs

`job/create <category>=<title>/<description>` - Creates a new job
        Categories are APP (Applications), BUILD (Building), CODE, MISC, PLOT, SPELL, and REQ (Request).

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

## Closing Jobs
`job/close <#>` - Closes a job
`job/close <#>=<message>` - Closes a job with a comment to the original submitter.

## Old  Jobs
Closed jobs in Ares are not archived to a BBS, as they are in some other systems.  Instead they stay around in the jobs system forever (or until you manually purge them).  This allows you to reopen and easily find old jobs.

`jobs/all` - Lists all jobs, even closed ones.

`jobs/search <category>=<value>` - Searches old jobs
        Category to search may be 'title' or 'submitter'.

If you run out of database space or want to archive your jobs offline, you can log the closed ones to a file and purge them.

`jobs/backup` - Prints out closed jobs, which you can save to a log file.
`jobs/purge` - Deletes all closed jobs.
`job/delete <#>` - Deletes a particular job.
