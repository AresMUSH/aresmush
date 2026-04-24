module AresMUSH
  module Scenes
    class InviteToSceneRequestHandler
      def handle(request)
        scene = Scene[request.args['id']]
        enactor = request.enactor
        invitee = Character.named(request.args['invitee'])
        
        if (!scene || !invitee)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.scene_is_private') }
        end
        
        if (scene.participants.include?(invitee))
          return { error: t('scenes.scene_already_in_scene') }
        end
        
        Scenes.invite_to_scene(scene, invitee, enactor)
                    
        {}
      end
    end
  end
end