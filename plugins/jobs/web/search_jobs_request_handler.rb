module AresMUSH
  module Jobs
    class SearchJobsRequestHandler
      def handle(request)
        searchText = (request.args[:searchText] || "").strip
        searchSubmitter = (request.args[:searchSubmitter] || "").strip
        searchTitle = (request.args[:searchTitle] || "").strip
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        job_admin = Jobs.can_access_jobs?(enactor)
        if (job_admin)
          jobs = Jobs.filtered_jobs(enactor, "ALL")
        else
          jobs = enactor.jobs.to_a
        end
        
        if (!searchTitle.blank?)
          jobs = jobs.select { |j| j.title =~ /\b#{searchTitle}\b/i }
        end

        if (!searchText.blank?)
          jobs = jobs.select { |j| "#{j.description} #{Jobs.visible_replies(enactor, j).map { |r| r.message }.join(' ')}" =~ /\b#{searchText}\b/i }
        end
        
        if (!searchSubmitter.blank?)
          jobs = jobs.select { |j| j.author && (j.author.name.upcase == searchSubmitter.upcase) }
        end
                
        
        jobs.sort_by { |j| j.created_at }.reverse.map { |j| {
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