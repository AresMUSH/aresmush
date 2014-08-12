module AresMUSH
  module Cookies
    def self.give_cookie(char, client)
      
      if (char == client.char)
        client.emit_failure t('cookies.cant_cookie_yourself')
        return
      end
      
      if (char.cookies_received.include?(client.char))
        client.emit_failure t('cookies.cookie_already_given', :name => char.name)
        return
      end
      
      char.cookies_received << client.char
      char.save
      
      client.emit_success t('cookies.cookie_given', :name => char.name)
      notify_cookie_recipient(char, client)
      Global.logger.info "#{client.name} gave #{char.name} a cookie."
    end
    
    def self.notify_cookie_recipient(char, client)
      other_client = Global.client_monitor.find_client(char)
      return if other_client.nil?
      
      other_client.emit_ooc t('cookies.cookie_received', :name => client.char.name)
    end
  end
end