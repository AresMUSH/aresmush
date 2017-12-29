module AresMUSH
  module Scenes
    class GetSceneTypesRequestHandler
      def handle(request)
        Scenes.scene_types.each_with_index.map { |s, i| { type: "sceneType", id: i + 1, name: s }}
      end
    end
  end
end

