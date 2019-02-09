module AresMUSH
  module Cookies
    def self.give_cookie(recipient, giver)
      
      if (recipient == giver)
        return t('cookies.cant_cookie_yourself')
      end
      
      cookies_from_giver = recipient.cookies_received.select { |c| c.giver == giver }
      if (!cookies_from_giver.empty?)
        return t('cookies.cookie_already_given', :name => recipient.name)
      end
      
      CookieAward.create(giver: giver, recipient: recipient)
      
      Login.emit_ooc_if_logged_in(recipient,  t('cookies.cookie_received', :name => giver.name))
      
      Global.logger.info "#{giver.name} gave #{recipient.name} a cookie."

      Achievements.award_achievement(giver, "cookie_given", 'community', "Gave a cookie.")

      return nil
    end
  end
end