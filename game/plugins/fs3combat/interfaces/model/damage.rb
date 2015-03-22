module AresMUSH
  
  class Damage
    include Mongoid::Document
    include Mongoid::Timestamps

    field :current_severity, :type => String
    field :initial_severity, :type => String
    field :last_treated, :type => Time
    field :healing_points, :type => Integer
    field :description, :type => String
    field :is_stun, :type => Boolean
  
    belongs_to :character, :class_name => "AresMUSH::Character"

    def is_stun?
      is_stun
    end
  
    def is_treatable?
      return true if self.last_treated.nil?
      time_to_go = 86400 - (Time.now - self.last_treated)
      return true if time_to_go < 0
      return false
    end
  
    def heal(points, was_treated = false)
      return if self.healing_points == 0
    
      if (points <= 0)
        points = 1
      end
      
      # Apply healing points
      self.healing_points = self.healing_points - points
      
      if (was_treated)
        self.last_treated = Time.now
      end
    
      # Wound going down a level.
      if (self.healing_points <= 0)
        new_severity_index = FS3Combat.damage_severities.index(self.current_severity) - 1
        new_severity = FS3Combat.damage_severities[new_severity_index]
        self.current_severity = new_severity
        self.healing_points = FS3Combat.healing_points(new_severity)
      end
    
      save
    end
  
  end
end