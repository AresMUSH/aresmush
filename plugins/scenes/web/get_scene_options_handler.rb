module AresMUSH
  module Scenes
    class GetSceneOptionsRequestHandler
      def handle(request)
        {
          scene_types: Scenes.scene_types.each_with_index.map { |s, i| { type: "sceneType", id: i + 1, name: s.titlecase }},
          scene_pacing: Scenes.scene_pacing
        }
        
      end
    end
  end
end

