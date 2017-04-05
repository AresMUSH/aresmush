module AresMUSH
  class Character
    def has_permission?(name)
      self.is_admin? || self.roles.any? { |r| r.has_permission?(name) }
    end
    
    def has_any_role?(names)
      if (!names.respond_to?(:any?))
        has_role?(names)
      else
        names.any? { |n| has_role?(n) }
      end
    end
    
    def is_admin?
      self.has_any_role?("admin")
    end  
        
    def is_master_admin?
      self == Game.master.master_admin
    end
  end
end