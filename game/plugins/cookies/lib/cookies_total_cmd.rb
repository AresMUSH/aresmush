module AresMUSH
  module Cookies
    class CookiesTotalCmd
      include CommandHandler
      
      def handle
        client.emit_ooc t('cookies.cookies_total_inv', :cookies => enactor.total_cookies)
      end
    end
  end
end
