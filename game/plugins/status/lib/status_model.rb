module AresMUSH
  class Character
    reference :last_ic_location, "AresMUSH::Room"

    attribute :afk_message
    attribute :is_afk, DataType::Boolean
    attribute :is_on_duty, DataType::Boolean
    attribute :is_playerbit, DataType::Boolean    
    
    default_values :default_status_values
    
    def self.default_status_values
       { is_on_duty: true }
    end
  end
end