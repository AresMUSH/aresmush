module AresMUSH
  
  class CombatLogMessage < Ohm::Model
    include ObjectModel
    
    attribute :message
    reference :combat_log, "AresMUSH::CombatLog"
  end
  
  class CombatLog < Ohm::Model
    include ObjectModel
    
    reference :combat, "AresMUSH::Combat"
    collection :combat_log_messages, "AresMUSH::CombatLogMessage"
    
    def add(msg)
      CombatLogMessage.create(message: msg, combat_log: self)
    end
  end
end
