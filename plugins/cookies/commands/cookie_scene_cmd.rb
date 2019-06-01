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
      
      def handle
        if (self.scene_num)
          scene = Scene[scene_num]
          if (!scene)
            client.emit_failure(t('cookies.invalid_scene'))
            return
          end
          chars = scene.participants
          message = t('cookies.giving_cookies_to_scene', :scene => scene.id)
        else
          chars = enactor_room.characters.select { |c| c != enactor && Login.is_online?(c) }
          message = t('cookies.giving_cookies_to_room')
        end
        client.emit_success message
        chars.each do |c|
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
