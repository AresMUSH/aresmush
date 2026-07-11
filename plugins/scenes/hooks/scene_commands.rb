module AresMUSH
  module Scenes
    module Hooks
    
      # Executes a custom scene command.
      #
      # @param [Character] enactor - The enacting character.
      # @param [Character] char - The character being acted for.
      # @param [Scene] scene - The active scene
      # @param [string] command - The command text
      # @param [string] args - Command arguments
      #
      # @return [string] - If you don't handle the command, return
      #   nil to allow processing to continue. If you DO handle the 
      #   command, return a message to the player with the command
      #   results (formatted for display).
      #
      # @example - See https://aresmush.com/tutorials/code/hooks/
      def self.handle_scene_command(enactor, char, scene, command, args)
        return nil
      end
    end
  end
end