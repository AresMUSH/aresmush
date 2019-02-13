---
toc: ~admin~ Managing the Game
summary: Old jobs archive.
---
# Jobs Archive

Closed jobs in Ares are not archived to a BBS, as they are in some other systems.  Instead they stay around in the jobs system forever (or until you manually purge them).  This allows you to reopen and easily find old jobs.

`jobs/all` - Lists all jobs, even closed ones.

`jobs/search <category>=<value>` - Searches old jobs
        Category to search may be 'title' or 'submitter'.

If you run out of database space or want to archive your jobs offline, you can log the closed ones to a file and purge them.

`jobs/backup` - Prints out closed jobs, which you can save to a log file.
`jobs/purge` - Deletes all closed jobs.
`job/delete <#>` - Deletes a particular job.