module AresMUSH
  module Cookies
    class CookiesTotalCmd
      include CommandHandler
      
      def help
        "`cookies/total` - Shows how many cookies you've ever gotten."
      end
      
      def handle
        client.emit_ooc t('cookies.cookies_total_inv', :cookies => enactor.total_cookies)
      end
    end
  end
end
