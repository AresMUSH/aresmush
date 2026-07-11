module AresMUSH
  module Scenes
    class CustomSceneDataHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (Global.plugin_manager.hooks_version == 1)
          custom = Scenes.custom_scene_data(enactor)
        else
          custom = Scenes::Hooks.scene_data(enactor)
        end
        
        custom || {}
      end
    end
  end
end