module AresMUSH
  module Cookies
    class CookieHereCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
                 
      def want_command?(client, cmd)
        cmd.root_is?("cookie") && cmd.switch_is?("here")
      end

      def handle
        client.emit_success t('cookies.giving_cookies_here')
        client.room.clients.each do |c|
          if (c != client)
            Cookies.give_cookie(c.char, client)
          end
        end
      end
    end
  end
end
