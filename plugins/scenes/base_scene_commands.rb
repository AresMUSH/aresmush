module AresMUSH
  module Scenes
    class BaseSceneCommands
      def handle(enactor, char, scene, command, args)
        case command
        when 'dance'
          Scenes.emit_pose(char, "#{char.name} dances.", false, true, nil, false, scene.room)
          return { command_response: "You dance." }
        end
        return nil
      end
    end
  end
end