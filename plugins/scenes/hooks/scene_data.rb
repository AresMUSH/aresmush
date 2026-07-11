module AresMUSH
  module Scenes
    module Hooks
    
      # Gets custom fields for display in an active scene.
      #
      # @param [Character] viewer - The character viewing the scene. 
      #    Probably shouldn't ever be nil but best to check anyway.
      #
      # @return [Hash] - A hash containing custom fields and values. 
      #    Ansi or markdown text strings must be formatted for display.
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.scene_data(viewer)
        return {}
      end
    end
  end
end
