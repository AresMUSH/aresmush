module AresMUSH
  class Role < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :is_restricted, DataType::Boolean
    
    index :name
  end
end