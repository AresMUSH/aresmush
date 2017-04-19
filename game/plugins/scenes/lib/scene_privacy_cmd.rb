module AresMUSH
  module Scenes
    class ScenePrivacyCmd
      include CommandHandler
      
      attr_accessor :privacy, :scene_num
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
          self.scene_num = integer_arg(args.arg1)
          self.privacy = titlecase_arg(args.arg2)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.privacy = titlecase_arg(args)
        end
      end
      
      def required_args
        {
          args: [ self.scene_num, self.privacy ],
          help: 'scenes'
        }
      end
      
      def check_privacy
        return t('scenes.invalid_privacy') if !Scenes.is_valid_privacy(self.privacy)
        return nil
      end
      
      def handle
        scene = Scene[self.scene_num]
        if (!scene)
          client.emit_failure t('scenes.scene_not_found')    
          return
        end
        
        if (!Scenes.can_manage_scene(enactor, scene))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        scene.update(private_scene: self.privacy == "Private")
        if (self.privacy)        
          client.emit_success t('scenes.scene_marked_private')
        else
          client.emit_success t('scenes.scene_marked_public')
        end
      end
    end
  end
end
