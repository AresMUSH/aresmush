module AresMUSH
  class Character
    attribute :birthdate, :type => DataType::Date
    attribute :demographics, :type => DataType::Hash, :default => {}
    attribute :groups, :type => DataType::Hash, :default => {}
    attribute :icon
    
    def age
      Demographics.calculate_age(demographic(:birthdate))
    end
    
    def actor
      demographic(:actor) || t('demographics.actor_not_set')
    end
    
    def demographic(key)
      name = key.to_s.downcase
      return self.birthdate if name == "birthdate"
      demo = self.demographics[name]
      return demo.blank? ? nil : demo
    end
    
    def update_demographic(key, value)
      name = key.to_s.downcase
      if (name == "birthdate")
        self.update(birthdate: value)
      else
        demo = self.demographics
        demo[name] = value
        self.update(demographics: demo)
      end
    end
    
    def group(name)
      self.groups[name.downcase]
    end
  end
  
end