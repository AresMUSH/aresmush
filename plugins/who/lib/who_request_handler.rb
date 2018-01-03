module AresMUSH
  module Who
    class WhoRequestHandler
      def handle(request)
        who =  Global.client_monitor.logged_in.sort_by { |client, char| char.name}
          .map { |client, char| {
          name: char.name,
          icon: WebHelpers.icon_for_char(char)
          }
        }
        
        scenes = Scene.all.select { |s| !s.completed }.map { |s| {
          location: s.location,
          people: s.participant_names.join(", ")
          }
        }
        
        {
          who_count: who.count,
          who: who,
          scenes_count: scenes.count,
          scenes: scenes
        }
      end
    end
  end
end


