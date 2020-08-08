---
toc: ~admin~ Managing the Game
summary: Managing the jobs system.
---

# Managing Job Categories

For general help on the jobs system, see [Jobs](/help/jobs).

> **Permission Required:** These commands require the Admin role or the permission: manage\_jobs

Job admins can create, edit and delete job categories.  Go to [Admin -> Setup -> Setup Job Categories](/jobcat-manage). Job category properties include:

* Name - A unique name for the category. Job categories will automatically be all-uppercase.
* Color - The color for the in-game job display, as an ansi code (e.g., \%xh\%xr). For the colors on the web portal, you can use custom CSS as described in the configuration tutorial on https://aresmush.com/tutorials/config/jobs.html#categories).
* Roles - All admins have access to all jobs. You can also allow other roles (such as builders or app staff) access to specific job categories.
* Template - Each category may have a template, which is used as starter text when someone creates a job with that category from the web portal. You can use this to highlight information that you want to see in that kind of job.

`job/categories` - Lists categories.
`job/createcategory <name>` - Creates a new category.
`job/deletecategory <name>` - Deletes a category. You must first move jobs to a different category.
`job/renamecategory <old name>=<new name>` - Renames a category.
`job/categorycolor <name>=<ansi code>` - Sets the category color.
`job/categoryroles <name>=<comma-separated roles list>` - Allow roles to access jobs in a category. Game admins always have access; there is no need to specify them.
`job/categorytemplate <name>=<text>` - Sets default job text for a category.