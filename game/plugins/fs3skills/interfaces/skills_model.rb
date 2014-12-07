module AresMUSH
  class Character
    field :fs3_attributes, :type => Hash, :default => {}
    field :fs3_action_skills, :type => Hash, :default => {}
    field :fs3_background_skills, :type => Hash, :default => {}
    field :fs3_languages, :type => Array, :default => []
    field :fs3_quirks, :type => Array, :default => []
    
    def ability(name)
      if fs3_attributes.has_key?(name)
        return fs3_attributes[name][:rating]
      elsif fs3_action_skills.has_key?(name)
        return action_skils[name][:rating]
      elsif fs3_background_skills.has_key?(name)
        return fs3_background_skills[name][:rating]
      else
        return 0
      end
    end
        
  end
end