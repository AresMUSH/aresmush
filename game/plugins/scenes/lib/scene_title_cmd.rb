module AresMUSH
  module Scenes
    class SceneTitleCmd
      include CommandHandler
      
      attr_accessor :name, :scene_num
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
          self.scene_num = integer_arg(args.arg1)
          self.name = titlecase_arg(args.arg2)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.name = titlecase_arg(cmd.args)
        end
      end
      
      def required_args
        {
          args: [ self.scene_num, self.name ],
          help: 'scenes info'
        }
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
        
        scene.update(title: self.name)
        if (scene.room)          
          scene.room.update(name: "Scene #{scene.id} - #{self.name}")
          scene.room.emit_ooc t('scenes.scene_rename_announce', :enactor_name => enactor_name, :scene_name => self.name)
        else
          client.emit_ooc t('scenes.scene_renamed')
        end
        
      end
    end
  end
end
