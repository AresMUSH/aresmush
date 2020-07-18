module AresMUSH
  module Scenes
    class SearchScenesRequestHandler
      def handle(request)

        search_log = (request.args[:searchLog] || "").strip
        search_participant = (request.args[:searchParticipant] || "").strip
        search_title = (request.args[:searchTitle] || "").strip
        search_tag = (request.args[:searchTag] || "").strip
        search_type = (request.args[:searchType] || "All").strip
        search_date = (request.args[:searchDate] || "").strip
        search_location = (request.args[:searchLocation] || "").strip
        search_token = request.args[:searchToken] || ""
        
        page = (request.args[:page] || "1").to_i
        
        enactor = request.enactor
        
        Global.dispatcher.spawn("Searching scene", nil) do  
          scenes = Scene.shared_scenes
      
          case search_type
          when "Recent"
            scenes = scenes[0..(scenes_per_page - 1)]
          when "Popular"
            scenes = scenes.select { |s| s.likes > 0 }
                           .sort_by { |s| s.likes }.reverse[0..(scenes_per_page - 1)]
          when "All"
            # Already set.
          else
            # Scene type filter
            scenes = scenes.select { |s| s.scene_type == search_type }
          end
              
          if (!search_title.blank?)
            scenes = scenes.select { |s| s.title =~ /#{search_title}/i }
          end
              
          if (!search_date.blank?)
            scenes = scenes.select { |s| s.icdate.start_with?(search_date) }
          end
      
          if (!search_participant.blank?)
            names = search_participant.upcase.split(" ")
            scenes = scenes.select { |s| (names & s.participants.map { |p| p.name.upcase }).count == names.count }
          end
      
          if (!search_tag.blank?)
            scenes = scenes.select { |s| s.tags.include?(search_tag.downcase) }
          end
      
          if (!search_location.blank?)
            scenes = scenes.select { |s| s.location =~ /\b#{search_location}\b/i }
          end
      
          if (!search_log.blank?)
            scenes = scenes.select { |s| "#{s.summary} #{s.scene_log.log}" =~ /\b#{search_log}\b/i }
          end
      
          scenes = scenes.sort_by { |s| s.date_shared || s.created_at }.reverse
          scenes_per_page = 30
      
          paginator = Paginator.paginate(scenes, page, scenes_per_page)
      
          if (paginator.out_of_bounds?)
            data = { scenes: [], pages: nil }
          else
        
            data = {  
              scenes: paginator.page_items.map { |s| Scenes.build_scene_summary_web_data(s) },
              pages: paginator.total_pages.times.to_a.map { |i| i+1 }
            }
            
          end
          
          Global.client_monitor.notify_web_clients(:search_results, "scenes|#{search_token}|#{data.to_json}", true) do |char|
            char == enactor
          end
        end
        {}
      end
    end
  end
end