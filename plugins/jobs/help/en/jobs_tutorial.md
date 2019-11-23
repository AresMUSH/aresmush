---
toc: 2 - Communicating
tutorial: true
summary: Tracking support tickets and admin tasks.
aliases:
- job_tutorial
- request_tutorial
---

## Jobs and Requests Tutorial

Ares has a lightweight job/request tracking system.  Requests are like support tickets in many web applications.  Players can track the status of a request, see who it's assigned to, and converse with the admin handling your request.  Admins can also create jobs for their own work.  

> **Tip:** Jobs and requests are part of the same system; the only difference is that for players it's called 'requests' and for game admin it's called 'jobs'.

Jobs and requests can be viewed and submitted via either the portal (usually under Help -> Requests/Jobs) or the `jobs` or `requests` command.

![Jobs Page Screenshot](https://aresmush.com/images/help-images/jobs.png)

[[toc]]

## Job Workflow

You can customize the job workflow for your game, but the default flow is:

* A job is submitted, either a player request or a task created by another admin. (NEW state)
* Someone handles the job and starts working on it.  (OPEN state)
* The admin handling the job communicates with other players/admins to gather information and determine a resolution.  (OPEN state)
* The admin responds to the job with the resolution and closes it.  (DONE state)
* Periodically, old, closed jobs are archived so they don't clutter up the main jobs display.  (ARCHIVE state)

## Comments and Replies

Comments on a job can be admin-only (visible only to other job admins) or responses directed to the player. 

* Use `job/discuss` or select "Admin Only" on the portal to make a comment visible only to other admins.
* Use `job/respond` or leave the "Admin Only" box _unchecked_ to respond to the player.

## Multi-Player Jobs and Queries

You can create a job on a player's behalf, essentially requesting their response, by using the `job/query` command or selecting the player in the "Submitter" field in the web portal.

You can loop in other players to a job by adding them as 'participants'. These players will see and be able to respond to the job as if it were their own request.

## Permissions

Anyone with the `can_acess_jobs` permission has access to the jobs system, but you can fine-tune access using roles.  Admins have access to all job categories, you can customize what other roles can access using the `job/categoryroles` command.

For example, you might add the 'builder' role to the BUILD category to allow builders to see building-related jobs.  If you create [custom roles](/tutorials/manage/roles.html) for app/plot staff, you could assign those roles to their respective job categories. They will not have access to other categories.

## Filtering and Searching

There are various filters to help you find jobs by state or by category.  Valid filters are:

* **Active** - Jobs that are active (not done or on hold) and/or have new activity since you last looked.  This is the default filter.
* **Mine** - Active jobs assigned to you.
* **Unfinished** - All jobs not marked done.
* **Unread** - Jobs with new activity.
* **(Category Name)** - Active jobs in the given category.
* **All** - All jobs.

You can also use the search feature on the web portal to search all jobs--including closed and archived ones.

## Seeing Jobs on Login

If you want to see new jobs when you log in, you might put `jobs/unread` or some other kind of filter in your connect commands. (See [onconnect](/help/onconnect).)

## Jobs Archive

Closed jobs in Ares are not archived to a BBS, but stay around in the jobs system forever (or until you manually purge them).  This allows you to reopen and easily find old jobs through the 'search' feature.

Jobs are small and database space shouldn't ever be an issue.  But if it is, and you want to archive your jobs offline, you can log the closed jobs to a file and purge them.

## Command Reference

[Request Commands](/help/requests) (for players)
[Job Commands](/help/jobs) (for admin)
[Managing Jobs](/help/requests) (for setting up the job system)


