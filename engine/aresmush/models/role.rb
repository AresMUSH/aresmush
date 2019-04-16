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
    before_delete :clear_char_roles
    
    def save_upcase_name
      self.name_upcase = self.name.upcase
    end
    
    def clear_char_roles
      Character.all.each do |c|
        if (c.roles.include?(self))
          c.roles.delete self
        end
      end
    end
    
    def has_permission?(name)
      permissions.include?(name)
    end
    
    def add_permission(name)
      return if self.has_permission?(name)
      new_permissions = self.permissions
      new_permissions << name
      self.update(permissions: new_permissions)
    end
    
    index :name
  end
end