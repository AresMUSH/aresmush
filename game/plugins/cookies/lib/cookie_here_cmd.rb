module AresMUSH
  module Cookies
    class CookieHereCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
                 
      def handle
        client.emit_success t('cookies.giving_cookies_here')
        enactor_room.character.each do |c|
          if (c != enactor && c.logged_in?)
            Cookies.give_cookie(c, client, enactor)
          end
        end
      end
    end
  end
end
