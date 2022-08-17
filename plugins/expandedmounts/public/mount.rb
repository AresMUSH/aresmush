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
    attribute :expanded_mount_type
    attribute :description
    attribute :shortdesc
    attribute :details, :type => DataType::Hash, :default => {}
    reference :bonded, "AresMUSH::Character"
  
    collection :damage, "AresMUSH::Damage"
    attribute :damaged_by, :type => DataType::Array, :default => []

    ## COMBAT

    reference :combat, "AresMUSH::Combat"

    attribute :freshly_damaged, :type => DataType::Boolean, :default => false
    
    reference :rider, 'AresMUSH::Combatant'
    collection :passengers, 'AresMUSH::Combatant', :riding_in

    before_delete :delete_damage

   
    # def combatant
    #   Combatant.find(character_id: self.id).first
    # end
    
    def delete_damage
      self.damage.each { |d| d.delete }
    end

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
      puts self.expanded_mount_type
      Global.read_config("expandedmounts", self.expanded_mount_type, "armor" )
    end

    def default_weapon
      Global.read_config("expandedmounts", self.expanded_mount_type, "weapons" ).first
    end

    def defense
      Global.read_config("expandedmounts", self.expanded_mount_type, "defense" )
    end

    def attack
      Global.read_config("expandedmounts", self.expanded_mount_type, "attack" )
    end

    def composure
      Global.read_config("expandedmounts", self.expanded_mount_type, "composure" )
    end
    
    def hitloc_type
      Global.read_config("expandedmounts", self.expanded_mount_type, "hitloc_chart" )
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

    def defense_stance_mod
      self.bonded.combatant.defense_stance_mod
    end

    def defense_mod
      self.bonded.combatant.defense_mod
    end

    def luck
      self.bonded.combatant.luck
    end

    def damage_mod
      (self.bonded.combatant.total_damage_mod + FS3.total_damage_mod(self)) / 2
    end

    def damage_lethality_mod
      self.bonded.combatant.damage_lethality_mod
    end

    def log(msg)
      self.combat.log(msg)
    end

    def roll_ability(ability, mod = 0)
      puts "Mythic ability #{ability}"
      #probably put methods here to determine reflexes, etc
      self.bonded.combatant.roll_ability(ability, mod)
    end

    def stance
      self.bonded.combatant.stance
    end

    def magic_shields
      self.bonded.magic_shields
    end

    def vehicle
      nil
    end

    def combatant_type
      self.expanded_mount_type
    end

    def inflict_damage(severity, desc, is_stun = false, is_crew_hit = false)
      FS3Combat.inflict_damage(self, severity, desc, is_stun, !self.combat.is_real)
    end

    def is_npc?
      false
    end

    def mount_type
      #Do NOT give this a value, it fucks with vanilla mount code.
    end

    def add_stress(num)
      self.bonded.combatant.add_stress(num)
    end

  end
end
