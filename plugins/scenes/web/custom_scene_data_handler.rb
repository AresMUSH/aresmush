module AresMUSH
  module Scenes
    class CustomSceneDataHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        Scenes.custom_scene_data(enactor) || {}
      end
    end
  end
end