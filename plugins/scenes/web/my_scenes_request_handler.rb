module AresMUSH
  module Scenes
    class MyScenesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        if (error)
          return []
        end
        
        Scene.all.select { |s| !s.completed && Scenes.is_watching?(s, enactor) }.map { |s|
          Scenes.build_live_scene_web_data(s, enactor)
        }
        
      end
    end
  end
end

