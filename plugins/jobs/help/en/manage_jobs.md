---
toc: ~admin~ Managing the Game
summary: Managing the jobs system.
---

For general help on the jobs system, see [Jobs](/help/jobs).

> **Permission Required:** These commands require the Admin role or the permission: manage\_jobs

You can use in-game commands to manage your job categories.

`job/categories` - Lists categories.
`job/createcategory <name>` - Creates a new category.
`job/deletecategory <name>` - Deletes a category. You must first move jobs to a different category.
`job/renamecategory <old name>=<new name>` - Renames a category.

## Category Color

You can give each category a color (used by the in-game job display; for web colors you can use custom CSS as described in the configuration tutorial on https://aresmush.com/tutorials/config/jobs.html)

`job/categorycolor <name>=<ansi code>` - Sets the category color.
  
## Category Roles

All game admins have access to all jobs. You can allow other roles (such as builders or app staff) access to specific job categories as well.

`job/categoryroles <name>=<comma-separated roles list>` - Allow roles to access jobs in a category. Game admins always have access; there is no need to specify them.
  
## Category Templates

Each category may have a template, which is used as starter text when someone creates a job with that category from the web portal. You can use this to highlight information that you want to see in that kind of job.

`job/categorytemplate <name>=<text>` - Sets default job text for a category.