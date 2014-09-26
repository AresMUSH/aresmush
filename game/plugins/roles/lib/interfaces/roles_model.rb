module AresMUSH
  class Character
    field :roles, :type => Array, :default => []
    
    before_create :set_default_role
    
    def set_default_role
      self.roles << 'everyone'
    end
    
    def has_role?(name)
      self.roles.include?(name)
    end

    def has_any_role?(names)
      if (!names.respond_to?(:any?))
        has_role?(names)
      else
        names.any? { |n| self.roles.include?(n) }
      end
    end
  end
end