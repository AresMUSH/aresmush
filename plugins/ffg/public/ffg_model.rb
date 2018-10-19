module AresMUSH
  class Character < Ohm::Model
    collection :ffg_skills, "AresMUSH::FfgSkill"
    collection :ffg_characteristics, "AresMUSH::FfgCharacteristic"
    collection :ffg_talents, "AresMUSH::FfgTalent"
    
    attribute :ffg_xp, :type => DataType::Integer
    attribute :ffg_story_points, :type => DataType::Integer
    attribute :ffg_force_rating, :type => DataType::Integer
    attribute :ffg_wound_threshold, :type => DataType::Integer
    attribute :ffg_strain_threshold, :type => DataType::Integer
    
    attribute :ffg_career
    attribute :ffg_archetype
    attribute :ffg_specializations, :type => DataType::Array, :default => []
    before_delete :delete_ffg_abilities
    
    def delete_ffg_abilities
      [ self.ffg_skills, self.ffg_characteristics, self.ffg_talents ].each do |list|
        list.each do |a|
          a.delete
        end
      end
    end
  end
  
  class FfgSkill < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :rating, :type => DataType::Integer
    reference :character, "AresMUSH::Character"
    index :name    
  end
  
  class FfgCharacteristic < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :rating, :type => DataType::Integer
    reference :character, "AresMUSH::Character"
    index :name
  end
  
  class FfgTalent < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :rating, :type => DataType::Integer
    attribute :ranked, :type => DataType::Boolean
    attribute :tier, :type => DataType::Integer
    reference :character, "AresMUSH::Character"
    index :name
    
    def rating_plus_tier
      self.rating > 1 ? self.tier + self.rating - 1 : self.tier
    end
  end
  
  
end