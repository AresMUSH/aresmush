module AresMUSH
  class Character
    field :roles, :type => Array, :default => []
    field :admin_note, :type => String
    
    before_create :set_default_role
    
    def set_default_role
      self.roles << 'everyone'
    end
    
    def has_role?(name)
      self.roles.include?(name)
    end
        
    def is_master_admin?
      self == Game.master.master_admin
    end
    
    def is_admin?
      self.has_any_role?(Global.read_config("roles", "game_admin"))
    end
    
  end
end