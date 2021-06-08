module AresMUSH
  module Scenes
    class GetSceneOptionsRequestHandler
      def handle(request)
        {
          scene_types: Scenes.scene_types.each_with_index.map { |s, i| { type: "sceneType", id: i + 1, name: s.titlecase }},
          scene_pacing: Scenes.scene_pacing,
          content_warnings: Global.read_config('scenes', 'content_warnings') || []          
        }
        
      end
    end
  end
end

