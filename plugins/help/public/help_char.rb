module AresMUSH
  class Character
    attribute :is_beginner, :type => DataType::Boolean, :default => false
    
    def is_beginner?
      self.is_beginner
    end
    
  end
end