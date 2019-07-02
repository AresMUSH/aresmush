module AresMUSH
  module FS3Combat
    class StartCombatRequestHandler
      def handle(request)
        scene_id = request.args[:scene_id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        scene = Scene[scene_id]
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        combat = FS3Combat.combat_for_scene(scene)
        
        if (combat)
          return { error: t('fs3combat.already_combat_for_scene')}
        end
        
        if (enactor.is_in_combat?) 
          return { error: t('fs3combat.you_are_already_in_combat') }
        end
        
        combat = Combat.create(:organizer => enactor, :is_real => true, scene: scene)
        FS3Combat.join_combat(combat, enactor.name, "Observer", enactor, nil)
        
        Scenes.add_to_scene(scene, t('fs3combat.combat_scene_started', :name => enactor.name), Game.master.system_character)
        
        {
          id: combat.id
        }
      end
    end
  end
end


