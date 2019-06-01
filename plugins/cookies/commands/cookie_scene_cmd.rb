module AresMUSH
  module Cookies
    class CookieSceneCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        if (cmd.args)
          self.scene_num = integer_arg(cmd.args)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
      end
      
      def required_args
        [ self.scene_num ]
      end
      
      def handle
        scene = Scene[scene_num]
        if (!scene)
          client.emit_failure(t('cookies.invalid_scene'))
          return
        end
        
        client.emit_success t('cookies.giving_cookies_to_scene', :scene => scene.id)
        scene.participants.each do |c|
          if (c != enactor)
            error = Cookies.give_cookie(c, enactor)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('cookies.cookie_given', :name => c.name)
            end
          end
        end
      end
    end
  end
end
