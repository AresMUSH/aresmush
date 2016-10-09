module AresMUSH
  class Character
    reference :demographics, "AresMUSH::DemographicInfo"
    
    before_delete :delete_demographics
    
    def delete_demographics
      self.demographics.delete if self.demographics
    end
    
    def age
      Demographics.calculate_age(demographic(:birthdate))
    end
    
    def demographic(name)
      return nil if !self.demographics
      self.demographics.send(name)
    end
    
    def get_or_create_demographics
      demo = self.demographics
      if (!demo)
        demo = DemographicInfo.create(character: self)
        self.update(demographics: demo)
      end
      demo
    end
  end
  
  class DemographicInfo < Ohm::Model
    include ObjectModel
    
    attribute :height
    attribute :physique
    attribute :skin
    attribute :fullname
    attribute :gender
    attribute :hair
    attribute :eyes
    attribute :birthdate, DataType::Date
    attribute :callsign
    
    reference :character, "AresMUSH::Character"
    
    before_create :set_default_demographics
    
    def set_default_demographics
      self.gender = "Other"
    end
  end
end