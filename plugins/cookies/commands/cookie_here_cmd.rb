module AresMUSH
  module Cookies
    class CookieHereCmd
      include CommandHandler
      
      def handle
        client.emit_success t('cookies.giving_cookies_here')
        enactor_room.characters.each do |c|
          if (c != enactor && Login.is_online?(c))
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
