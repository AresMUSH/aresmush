module AresMUSH
  module FS3Combat
    class CombatSceneCmd
      include CommandHandler

      attr_accessor :scene_id
      
      def parse_args
        self.scene_id = integer_arg(cmd.args)  
      end
      
      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
              
        combat = enactor.combat
        scene = Scene[self.scene_id]
        
        if (!scene)
          client.emit_failure t('fs3combat.invalid_scene')
          return
        end
        
        if (!Scenes.can_read_scene?(enactor, scene))
          client.emit_failure t('fs3combat.cant_link_scene')
          return
        end
        
        combat.update(scene: scene)
        client.emit_success t('fs3combat.scene_set', :scene => scene.id)
        
      end
    end
  end
end