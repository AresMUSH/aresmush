module AresMUSH
  class Character
    reference :demographics, "AresMUSH::DemographicInfo"
    
    before_delete :delete_demographics
    
    def delete_demographics
      self.demographics.delete if self.demographics
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
    attribute :gender, :default => "Other"
    attribute :hair
    attribute :eyes
    attribute :birthdate, :type => DataType::Date
    attribute :callsign
    attribute :actor
    
    reference :character, "AresMUSH::Character"
  end
end