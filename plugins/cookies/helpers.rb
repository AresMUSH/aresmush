module AresMUSH
  module Cookies
    def self.give_cookie(recipient, client, giver)
      
      if (recipient == giver)
        client.emit_failure t('cookies.cant_cookie_yourself')
        return
      end
      
      cookies_from_giver = recipient.cookies_received.select { |c| c.giver == giver }
      if (!cookies_from_giver.empty?)
        client.emit_failure t('cookies.cookie_already_given', :name => recipient.name)
        return
      end
      
      CookieAward.create(giver: giver, recipient: recipient)
      
      client.emit_success t('cookies.cookie_given', :name => recipient.name)

      Global.client_monitor.emit_ooc_if_logged_in(recipient,  t('cookies.cookie_received', :name => giver.name))
      
      Global.logger.info "#{giver.name} gave #{recipient.name} a cookie."

      Achievements.award_achievement(giver, "cookie_given", :community, "Gave a cookie.")
    end
  end
end