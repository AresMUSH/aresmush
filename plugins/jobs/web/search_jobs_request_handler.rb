module AresMUSH
  module Jobs
    class SearchJobsRequestHandler
      def handle(request)
        search_text = (request.args[:searchText] || "").strip
        search_submitter = (request.args[:searchSubmitter] || "").strip
        search_title = (request.args[:searchTitle] || "").strip
        search_category = (request.args[:searchCategory] || "").strip
        search_status = (request.args[:searchStatus] || "").strip
        search_token = request.args[:searchToken] || ""
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        Global.dispatcher.spawn("Searching scene", nil) do  
        
          job_admin = Jobs.can_access_jobs?(enactor)
          if (job_admin)
            jobs = Jobs.accessible_jobs(enactor, nil, true)
          else
            jobs = enactor.requests.to_a
          end
        
          if (!search_category.blank?)
            jobs = jobs.select { |j| j.category == search_category }
          end
        
          if (!search_status.blank?)
            jobs = jobs.select { |j| j.status == search_status }
          end
        
        
          if (!search_title.blank?)
            jobs = jobs.select { |j| j.title =~ /#{search_title}/i }
          end

          if (!search_submitter.blank?)
            jobs =  jobs.select { |j| Jobs.has_participant_by_name?(j, search_submitter) }
          end

          if (!search_text.blank?)
            jobs = jobs.select { |j| "#{j.description} #{Jobs.visible_replies(enactor, j).map { |r| r.message }.join(' ')}" =~ /\b#{search_text}\b/i }
          end
                        
        
          data = jobs.sort_by { |j| j.created_at }.reverse.map { |j| {
              id: j.id,
              title: j.title,
              unread: j.is_unread?(enactor),
              created: j.created_date_str(enactor),
              category: j.category,
              status: j.status,
              author: j.author_name,
              assigned_to: j.assigned_to ? j.assigned_to.name : "--"
            }}
            
          Global.client_monitor.notify_web_clients(:search_results, "jobs|#{search_token}|#{data.to_json}", true) do |char|
            char == enactor
          end
                        
        end
      end
    end
  end
end