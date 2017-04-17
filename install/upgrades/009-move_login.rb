module AresMUSH
  
  class Character
    reference :login_status, "AresMUSH::LoginStatus"
  end
  
  class LoginStatus < Ohm::Model
    include ObjectModel
    reference :character, "AresMUSH::Character"
    attribute :terms_of_service_acknowledged, :type => DataType::Time
    attribute :last_ip
    attribute :last_on
    attribute :last_hostname
  end
  
  puts "======================================================================="
  puts "Moves login status fields onto the character itself."
  puts "======================================================================="
  
  Character.all.each do |c|
    status = c.login_status
    if (status)
      c.update(last_on: status.last_on)
      c.update(last_ip: status.last_ip)
      c.update(last_hostname: status.last_hostname)
      c.update(terms_of_service_acknowledged: status.terms_of_service_acknowledged)
    
      status.delete
    end
    
      c.update(login_status_id: nil)
  end
  
  puts "Upgrade complete!"
end



