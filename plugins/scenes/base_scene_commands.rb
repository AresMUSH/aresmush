module AresMUSH
  module Scenes
    class BaseSceneCommands
      def handle(enactor, char, scene, command, args)
        custom = CustomSceneCommands.new
        result = custom.handle(enactor, char, scene, command, args)
        
        return result if result
        
        case command
        when 'dance'
          Scenes.emit_pose(char, "#{char.name} dances.", false, true, nil, false, scene.room)
          return { command_response: "You dance." }
        else
          return { command_response: "Unrecognized command."}
        end
      end
    end
  end
end