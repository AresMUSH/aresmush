---
toc: ~admin~ Managing the Game
summary: Admin work assignments.
aliases:
- ticket
---
# Jobs

The Jobs system is used by the game administrators to track work requests and to-do items.  Players can submit their own requests.

> **Permissions Requred:** Working with jobs requires the access_jobs permission.

## Viewing  Jobs

The jobs list shows you the jobs. 

`jobs` - Lists jobs
`job <#>` - Views a job.

By default the jobs list only shows active jobs.  You can look at old ones too:

`jobs/all` - Shows all jobs, even old ones.  Add a number after 'all' to see additional pages (e.g. jobs/all2, jobs/all3, etc.)

You can mark jobs as read with the catchup command:

`jobs/catchup` - Marks all jobs as read.
`jobs/catchup <number>` - Mark a specific job as read.

> Note:  Some games will have multiple staff roles with limited access to certain categories.  For example - builders may only be able to access the 'BUILD' category.  You can still create jobs in other categories, but they are treated as _requests_ (see [Requests](/help/request)).

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
`jobs/mine`, `jobs/active` - Shortcuts for the common filters.

## Job Workflow

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

## Old  Jobs

Closed jobs in Ares are not archived to a BBS, as they are in some other systems.  Instead they stay around in the jobs system forever (or until you manually purge them).  This allows you to reopen and easily find old jobs.

`jobs/all` - Lists all jobs, even closed ones.

`jobs/search <category>=<value>` - Searches old jobs
        Category to search may be 'title' or 'submitter'.

If you run out of database space or want to archive your jobs offline, you can log the closed ones to a file and purge them.

`jobs/backup` - Prints out closed jobs, which you can save to a log file.
`jobs/purge` - Deletes all closed jobs.
`job/delete <#>` - Deletes a particular job.