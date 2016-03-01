module AresMUSH
  class Character
    field :admin_note, :type => String
    
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
    
    def is_master_admin?
      self == Game.master.master_admin
    end
    
    def is_admin?
      self.has_any_role?(Global.read_config("roles", "game_admin"))
    end
  end
end