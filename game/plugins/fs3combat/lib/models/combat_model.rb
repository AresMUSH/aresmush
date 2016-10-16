module AresMUSH
  class Character    
    reference :combatant, "AresMUSH::Combatant"
    collection :damage, "AresMUSH::Damage"
    
    before_delete :delete_damage
      
    def delete_damage
      self.damage.each { |d| d.delete }
    end
    
    def patients
      Healing.find(character_id: self.id).map { |h| h.patient }
    end
    
    def doctors
      Healing.find(patient_id: self.id).map { |h| h.character }
    end
    
    def is_in_combat?
      combatant
    end
  end
  
  class Room
    attribute :is_hospital, :type => DataType::Boolean
    
    index :is_hospital
  end
  
end