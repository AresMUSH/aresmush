module AresMUSH
  class Role < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :is_restricted, :type => DataType::Boolean
    attribute :permissions, :type => DataType::Array, :default => []
    
    index :name_upcase
    
    before_save :save_upcase_name
    
    def save_upcase_name
      self.name_upcase = self.name.upcase
    end
    
    def has_permission?(name)
      permissions.include?(name)
    end
    
    index :name
  end
end