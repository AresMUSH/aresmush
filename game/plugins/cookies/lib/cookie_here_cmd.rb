module AresMUSH
  module Cookies
    class CookieHereCmd
      include CommandHandler
                 
      def handle
        client.emit_success t('cookies.giving_cookies_here')
        enactor_room.characters.each do |c|
          if (c != enactor && c.is_online?)
            Cookies.give_cookie(c, client, enactor)
          end
        end
      end
    end
  end
end
