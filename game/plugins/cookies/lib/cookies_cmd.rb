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
        
        template = BorderedDisplayTemplate.new "#{cookies_given}"
        client.emit template.render
      end
    end
  end
end
