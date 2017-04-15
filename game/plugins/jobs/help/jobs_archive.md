---
toc: 
summary: 
categories:
- admin
---
Closed jobs in Ares are not archived to a BBS, as they are in some other systems.  Instead they stay around in the jobs system forever (or until you manually purge them).  This allows you to reopen and easily find old jobs.

Once a job is closed, you will only see it if it has new activity or you use the /all option:

`jobs/all` - Lists all jobs, even closed ones. 
        Note: When doing multiple pages, you put the number before the slash, like jobs2/all to see page 2

`jobs/search <category>=<value>` - Searches old jobs
        Category to search may be 'title' or 'submitter'.

If you run out of database space or want to archive your jobs offline, you can log the closed ones to a file and purge them.

`jobs/backup` - Prints out closed jobs, which you can save to a log file.
`jobs/purge` - Deletes all closed jobs.
`job/delete <#>` - Deletes a particular job.

