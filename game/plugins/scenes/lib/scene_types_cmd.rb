module AresMUSH
  module Scenes
    class SceneTypesCmd
      include CommandHandler
      
      def handle
        client.emit_ooc t('scenes.scene_types', :types => Scenes.scene_types.join(", "))
      end
    end
  end
end
