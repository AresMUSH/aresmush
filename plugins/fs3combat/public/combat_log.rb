module AresMUSH
  
  class CombatLogMessage < Ohm::Model
    include ObjectModel
    
    attribute :message
    attribute :timestamp
    reference :combat_log, "AresMUSH::CombatLog"
  end
  
  class CombatLog < Ohm::Model
    include ObjectModel
    
    reference :combat, "AresMUSH::Combat"
    collection :combat_log_messages, "AresMUSH::CombatLogMessage"
    
    before_delete :delete_messages
    
    def delete_messages
      combat_log_messages.each { |c| c.delete }
    end
    
    def add(msg)
      CombatLogMessage.create(timestamp: Time.now.to_f, message: msg, combat_log: self)
    end
  end
end
