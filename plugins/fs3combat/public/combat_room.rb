module AresMUSH
  class Room
    attribute :is_hospital, :type => DataType::Boolean
    
    index :is_hospital
  end
  
end