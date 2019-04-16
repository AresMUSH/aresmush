module AresMUSH
  module Scenes
    class SceneWebStartCmd
      include CommandHandler
      
      attr_accessor :location, :privacy
      
      # scene/start (location) -->  Temproom/private
      # scene/start (location)=(privacy) --> Temproom with privacy setting
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.location = titlecase_arg(args.arg1)
          self.privacy = titlecase_arg(args.arg2)
        else
          self.location = titlecase_arg(cmd.args)
          self.privacy = "Private"
        end
      end
      
      def required_args
        [ self.location, self.privacy ]
      end

      def check_privacy
        return t('scenes.invalid_privacy') if !Scenes.is_valid_privacy?(self.privacy)
        return nil
      end
      
      def check_approved
        return t('scenes.must_be_approved') if !enactor.is_approved?
        return nil
      end
            
      def handle
        
        private_scene = self.privacy == "Private"
        
        if self.location == 'Here'
          self.location = enactor_room.name_and_area
        end
          
        scene = Scenes.start_scene(enactor, self.location, private_scene, Scenes.scene_types.first, true)
        client.emit_success t('scenes.web_scene_started', :num => scene.id)
        
      end
    end
  end
end
