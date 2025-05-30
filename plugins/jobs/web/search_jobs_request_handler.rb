module AresMUSH
  module Jobs
    class SearchJobsRequestHandler
      def handle(request)
        search_text = (request.args['searchText'] || "").strip
        search_submitter = (request.args['searchSubmitter'] || "").strip
        search_title = (request.args['searchTitle'] || "").strip
        search_category = (request.args['searchCategory'] || "").strip
        search_status = (request.args['searchStatus'] || "").strip
        search_token = request.args['searchToken'] || ""
        search_tag = request.args['searchTag'] || ""
        search_custom = request.args['searchCustom'] || {}
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
            jobs = jobs.select { |j| j.job_category.name == search_category }
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
                        
          if (!search_tag.blank?)
            jobs_with_tag = ContentTag.find(content_type: 'AresMUSH::Job', name: search_tag.downcase).map { |t| "#{t.content_id}" }
            jobs = jobs.select { |c| jobs_with_tag.include?("#{c.id}") }
          end
        
          search_custom.each do |key, field|
            if (!field['search'].blank?)
              if (field['field_type'] == 'date')
                search_date = OOCTime.parse_date(field['search'])
                if (!search_date)
                  Global.logger.warn "Invalid format for custom date search: #{search_date}."
                  jobs = []
                else
                  jobs = jobs.select { |j| Jobs.get_custom_field(j, key) == search_date.to_s }
                end
              else
                jobs = jobs.select { |j| (Jobs.get_custom_field(j, key) || "").upcase == field['search'].upcase }
              end
            end
          end
          
          data = jobs.sort_by { |j| j.created_at }.reverse.map { |j| {
              id: j.id,
              title: j.title,
              unread: j.is_unread?(enactor),
              created: j.created_date_str(enactor),
              category: j.job_category.name,
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