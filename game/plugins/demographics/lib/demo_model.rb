module AresMUSH
  class Character
    reference :demographics, "AresMUSH::DemographicInfo"
    
    def age
      Demographics.calculate_age(demographic(:birthdate))
    end
    
    def demographic(name)
      return nil if !self.demographics
      self.demographics.send(name)
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