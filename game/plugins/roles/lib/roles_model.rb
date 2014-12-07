module AresMUSH
  class Character
    field :roles, :type => Array, :default => []
    
    before_create :set_default_role
    
    def set_default_role
      self.roles << 'everyone'
    end
  end
end