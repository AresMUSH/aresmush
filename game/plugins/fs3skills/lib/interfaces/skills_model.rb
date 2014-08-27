module AresMUSH
  class Character
    field :fs3_attributes, :type => Hash, :default => {}
    field :action_skills, :type => Hash, :default => {}
    field :background_skills, :type => Hash, :default => {}
    field :languages, :type => Array, :default => []
    field :quirks, :type => Array, :default => []
    
    def ability(name)
      if fs3_attributes.has_key?(name)
        return fs3_attributes[name][:rating]
      elsif action_skills.has_key?(name)
        return action_skils[name][:rating]
      elsif background_skills.has_key?(name)
        return background_skills[name][:rating]
      else
        return 0
      end
    end
        
  end
end