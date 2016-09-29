module AresMUSH
  module Cookies
    def self.give_cookie(recipient, client, giver)
      
      if (recipient.client == giver)
        client.emit_failure t('cookies.cant_cookie_yourself')
        return
      end
      
      if (recipient.cookies_received.include?(giver))
        client.emit_failure t('cookies.cookie_already_given', :name => recipient.name)
        return
      end
      
      recipient.cookies_received << giver
      recipient.save
      
      client.emit_success t('cookies.cookie_given', :name => recipient.name)

      other_client = recipient.client
      if (other_client)
        other_client.emit_ooc t('cookies.cookie_received', :name => giver.name)
      end
      
      Global.logger.info "#{client.name} gave #{recipient.name} a cookie."
    end
  end
end