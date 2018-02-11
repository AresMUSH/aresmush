module AresMUSH
  module Cookies
    class CookieSceneCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        self.scene_num = integer_arg(cmd.args)
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
        
        client.emit_success t('cookies.giving_cookies_to_scene', :scene => scene.title)
        scene.participants.each do |c|
          if (c != enactor)
            Cookies.give_cookie(c, client, enactor)
          end
        end
      end
    end
  end
end
