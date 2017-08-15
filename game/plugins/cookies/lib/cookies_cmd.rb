module AresMUSH
  module Cookies
    class CookiesCmd
      include CommandHandler
      
      def handle
        cookie_recipients = enactor.cookies_given
        if (cookie_recipients.empty?)
          cookies_given = t('cookies.cookies_not_given_this_week')
        else
          cookies_given = cookie_recipients.map { |c| c.recipient.name }.join(", ")
          cookies_given = t('cookies.cookies_given_this_week', :cookies => cookies_given)
        end
        
        cookies_total = t('cookies.cookies_total', :cookies => enactor.total_cookies)
        list = [ cookies_given, "", cookies_total ]
        template = BorderedListTemplate.new list
        client.emit template.render
      end
    end
  end
end
