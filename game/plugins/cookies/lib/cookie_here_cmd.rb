module AresMUSH
  module Cookies
    class CookieHereCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
                 
      def handle
        client.emit_success t('cookies.giving_cookies_here')
        enactor_room.clients.each do |c|
          if (c != client)
            Cookies.give_cookie(c.char, client)
          end
        end
      end
    end
  end
end
