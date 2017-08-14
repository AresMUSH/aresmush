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

[[help jobs]]
[[help jobs/catchup]]

## Filtering  Jobs

You can change what jobs you see in the jobs list.  If you're a coder, you could set your filter to only show jobs in the CODE category.  Or you might set the filter so it only shows jobs that are assigned to you.

> **Tip:** Your job filter is remembered when you log out.

Valid filters are:

* Active - Jobs that are open and/or have new activity since you last looked.  This is the default filter.
* All - All jobs, open or closed.
* Mine - Jobs that are open and assigned to you.
* (Category Name) - Jobs in the given category.

[[help jobs/filter]]

## Job Workflow

The basic workflow for jobs goes like this:

* Someone creates a job.  State => NEW
* An admin handles or assigns a job.  State => OPEN
* An admin adds comments to a job.  Other admins or the submitter can reply.  Job comments can be admin-only or visible to the submitter.  A job can be placed on HOLD if it's waiting for something.
* An admin closes the job.  State => DONE

## Creating Jobs

Jobs can be created by players using the `request` command, by coded systems (e.g. apps), or manually.

[[help job/create]]

## Changing Job Status

You can change various attributes about the job, including its status and who it's assigned to.

[[help job/assign]]
[[help job/handle]]
[[help job/status]]
[[help job/title]]
[[help job/cat]]   

## Adding Job Comments

There are two ways for admins to comment upon a job.  A `discuss` comment is for admin eyes only, and will never be seen by the original submitter.  A `respond` comment is **viewable by the submitter**.

[[help job/comment]]
[[help job/deletereply]]

Players can automatically see responses on their own requests; there's no need to send them mail.  But if you want to send a mail related to a job that wasn't their own request, you can use the `job/mail` command to add a comment to the job and send that comment in a mail message.

[[help job/mail]]

## Closing Jobs

When you're done with the job, close it and it will be archived.

[[help job/close]]

## Old  Jobs

Closed jobs in Ares are not archived to a BBS, as they are in some other systems.  Instead they stay around in the jobs system forever (or until you manually purge them).  This allows you to reopen and easily find old jobs.

Once a job is closed, you will only see it if it has new activity or you use the /all option on the jobs list.  You can also search for a job.

[[help job/search]]

If you run out of database space or want to archive your jobs offline, you can log the closed ones to a file and purge them.

[[help jobs/backup]]
[[help jobs/purge]]
[[help job/delete]]