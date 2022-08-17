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

    ## COMBAT

    reference :combat, "AresMUSH::Combat"

    attribute :freshly_damaged, :type => DataType::Boolean, :default => false
    
    reference :rider, 'AresMUSH::Combatant'
    collection :passengers, 'AresMUSH::Combatant', :riding_in

    before_delete :delete_damage

   
    # def combatant
    #   Combatant.find(character_id: self.id).first
    # end
    
    # def delete_damage
    #   self.damage.each { |d| d.delete }
    # end

    def weapon
      self.bonded.combatant.weapon
    end
    
 
    def is_noncombatant?
      !self.is_in_combat?
    end

    def is_mount?
      true
    end
    
    
    def patients
      Healing.find(character_id: self.id).map { |h| h.patient }
    end
    
    def doctors
      Healing.find(patient_id: self.id).map { |h| h.character }
    end
    
    def is_in_combat?
      !!combat
    end
    
    def armor
      Global.read_config("expandedmounts", self.mount_type, "armor" )
    end

    def default_weapon
      Global.read_config("expandedmounts", self.mount_type, "weapons" ).first
    end

    def defense
      Global.read_config("expandedmounts", self.mount_type, "defense" )
    end

    def attack
      Global.read_config("expandedmounts", self.mount_type, "attack" )
    end

    def composure
      Global.read_config("expandedmounts", self.mount_type, "composure" )
    end
    
    def hitloc_type
      Global.read_config("expandedmounts", self.mount_type, "hitloc_chart" )
    end

    def total_damage_mod
      FS3Combat.total_damage_mod(self)
    end

    def riding_in
      false
    end

    def is_in_vehicle?
      false
    end




  end
end
