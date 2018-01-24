module AresMUSH
  module Jobs
    class JobsRequestHandler
      def handle(request)
        topic = request.args[:topic]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        
        jobs = Jobs.filtered_jobs(enactor, "ACTIVE").sort_by { |j| j.created_at }.reverse
        
        jobs.map { |j| {
          id: j.id,
          title: j.title,
          unread: j.is_unread?(enactor),
          created: j.created_date_str(enactor),
          category: j.category,
          status: j.status,
          author: j.author_name,
          assigned_to: j.assigned_to ? j.assigned_to.name : "--"
        }}
        
      end
    end
  end
end