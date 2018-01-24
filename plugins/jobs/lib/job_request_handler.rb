module AresMUSH
  module Jobs
    class JobRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        
        if (!job)
          return { error: "Invalid job." }
        end
        
        Jobs.mark_read(job, enactor)
        
        
        {
          id: job.id,
          title: job.title,
          unread: job.is_unread?(enactor),
          category: job.category,
          status: job.status,
          created: job.created_date_str(enactor),
          is_open: job.is_open?,
          author: { name: job.author_name, icon: WebHelpers.icon_for_char(job.author) },
          assigned_to: job.assigned_to ? job.assigned_to.name : "--",
          description: WebHelpers.format_markdown_for_html(job.description),
          replies: Jobs.visible_replies(enactor, job).map { |r| {
            author: { name: r.author_name, icon: WebHelpers.icon_for_char(r.author) },
            message: WebHelpers.format_markdown_for_html(r.message),
            created: r.created_date_str(enactor),
            admin_only: r.admin_only
          }}
        }
      end
    end
  end
end