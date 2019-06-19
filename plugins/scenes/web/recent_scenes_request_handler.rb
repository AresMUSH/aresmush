module AresMUSH
  module Scenes
    class RecentScenesRequestHandler
      def handle(request)
        Scenes.get_recent_scenes_web_data
      end
    end
  end
end

