module AresMUSH
  class Character
    before_delete :delete_cookies
    attribute :total_cookies, :type => DataType::Integer, :default => 0
    
    def delete_cookies
      cookies_given.each { |c| c.delete }
    end
    
    def cookies_received
      CookieAward.find(recipient_id: self.id)
    end
    
    def cookies_given
      CookieAward.find(giver_id: self.id)
    end
  end
end