module AresMUSH
  class Character
    reference :last_ic_location, "AresMUSH::Room"

    attribute :afk_message
    attribute :is_afk, DataType::Boolean
    attribute :is_on_duty, DataType::Boolean
    attribute :is_playerbit, DataType::Boolean    
    
    before_create :set_default_status
    
    def set_default_status
      self.is_on_duty = true
    end
  end
end