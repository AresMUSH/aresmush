module AresMUSH
  class Character
   
    collection :event_signups, "AresMUSH::EventSignup"
    before_delete :delete_signups
    
    def delete_signups
      event_signups.each { |e| e.delete }
    end
  end
end