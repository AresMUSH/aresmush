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
    
    def add(msg)
      CombatLogMessage.create(timestamp: Time.utc(0001,01,01).to_i, message: msg, combat_log: self)
    end
  end
end
