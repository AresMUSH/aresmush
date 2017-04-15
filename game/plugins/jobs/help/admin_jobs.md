---
toc: Player Management
summary: Managing jobs and requests.
categories:
- admin
aliases:
- job
- requests
- request
---
The Jobs system allows you to track admin work assignments.

`jobs` - Lists active jobs.
`job <#>` - Views a job.

Jobs can be created by players using the `request` command, by coded systems (e.g. apps), or manually.

`job/create <category>=<title>/<description>` - Creates a new job
        Default categories are APP (Applications), BUILD (Building), CODE, MISC, RP and REQ (Request).

You can change various attributes about the job, including its status and who it's assigned to.

`job/assign <#>=<player>`                  `job/handle <#>` 
`job/status <#>=<status>`                  `job/cat <#>=<category>` 
`job/title <#>=<title>`   
        Default status values are NEW, OPEN, HOLD (job on hold) and DONE.

There are two ways for admins to comment upon a job.  A `discuss` comment is for admin eyes only, and will never be seen by the original submitter.  A `respond` comment is **viewable by the submitter**.

`job/discuss <#>=<comment>` - Comments on a job (only admins may view)
`job/respond <#>=<message>` - Comments on a job (admins and submitter may view)
`job/deletereply <#>=<reply#>` - Deletes a reply.

When you're done with the job, close it and it will be archived.

`job/close <#>` - Closes a job
`job/close <#>=<message>` - Closes a job with a comment to the original submitter.

See `ahelp jobs archive` for more information about what happens to closed jobs.
