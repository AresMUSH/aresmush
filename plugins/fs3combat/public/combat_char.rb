module AresMUSH
  class Character    
    collection :damage, "AresMUSH::Damage"
    attribute :combats_participated_in, :type => DataType::Integer
    
    before_delete :delete_damage
      
    def combatant
      Combatant.find(character_id: self.id).first
    end
    
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
      !!combatant
    end
    
    def combat
      self.combatant ? self.combatant.combat : nil
    end
  end
end