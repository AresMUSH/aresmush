module AresMUSH
  module Scenes
    class RelatedSceneCmd
      include CommandHandler
      
      attr_accessor :scene1_num, :scene2_num, :add_scene
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.scene1_num = integer_arg(args.arg1)
        self.scene2_num = integer_arg(args.arg2)
        self.add_scene = cmd.switch_is?("addrelated")
      end
      
      def required_args
        [ self.scene1_num, self.scene2_num ]
      end
      
      def handle        
        scene1 = Scene[self.scene1_num]
        scene2 = Scene[self.scene2_num]
        if (!scene1)
          client.emit_failure t('scenes.scene_not_found_num', :num => self.scene1_num)
          return
        end
        
        if (!scene2)
          client.emit_failure t('scenes.scene_not_found_num', :num => self.scene2_num)
          return
        end
        
        if (scene1.id == scene2.id) 
          client.emit_failure t('scenes.no_recursive_link')
          return
        end
        
        if (!scene1.shared || !scene2.shared)
          client.emit_failure t('scenes.cant_link_unshared_scenes')
          return
        end
        
        if (!Scenes.can_edit_scene?(enactor, scene1) || !Scenes.can_edit_scene?(enactor, scene2))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        link = SceneLink.find_link(scene1, scene2)
                
        if (self.add_scene)
          if (link)
            client.emit_failure t('scenes.already_linked')
            return
          end
          
          SceneLink.create(log1: scene1, log2: scene2)          
          client.emit_success t('scenes.link_added')  
        else
          if (!link)
            client.emit_failure t('scenes.not_linked')
            return
          end
          link.delete
          client.emit_success t('scenes.link_removed')  
        end
      end
    end
  end
end
