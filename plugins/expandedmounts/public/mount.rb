module AresMUSH
  class Mount < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    index :name_upcase
    
    before_save :save_upcase_name
    
    def save_upcase_name
      self.name_upcase = self.name.upcase
    end

    attribute :birthdate, :type => DataType::Date
    attribute :mount_type
    attribute :description
    attribute :shortdesc
    attribute :details, :type => DataType::Hash, :default => {}
    reference :bonded, "AresMUSH::Character"

    collection :damage, "AresMUSH::Damage"
    reference :combat, "AresMUSH::Combat"
    collection :passengers, 'AresMUSH::Combatant', :riding_in

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

    def armor
      FS3Combat.vehicle_stat(self.mount_type, "armor")
    end
    
    def hitloc_type
      FS3Combat.vehicle_stat(self.mount_type, "hitloc_chart")
    end

    def total_damage_mod
      FS3Combat.total_damage_mod(self)
    end

  end
end
