module AresMUSH
  module Cookies
    class CookiesCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        cookie_total = t('cookies.cookies_total', :cookies => client.char.cookie_count)
        cookie_recipients = client.char.cookies_given
        if (cookie_recipients.empty?)
          cookies_given = t('cookies.cookies_not_given_this_week')
        else
          cookies_given = cookie_recipients.map { |c| c.name }.join(", ")
          cookies_given = t('cookies.cookies_given_this_week', :cookies => cookies_given)
        end
        client.emit BorderedDisplay.text "#{cookies_given}%R%R#{cookie_total}"
      end
    end
  end
end
