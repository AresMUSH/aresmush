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
    attribute :about
    attribute :description
    attribute :shortdesc
    attribute :details, :type => DataType::Hash, :default => {}
    reference :bonded, "AresMUSH::Character"

    collection :damage, "AresMUSH::Damage"
    attribute :damaged_by, :type => DataType::Array, :default => []

    ## COMBAT

    reference :combat, "AresMUSH::Combat"
    attribute :armor_name
    attribute :armor_specials, :type => DataType::Array, :default => []
    collection :magic_armor_specials, "AresMUSH::MagicArmorSpecials"
    attribute :freshly_damaged, :type => DataType::Boolean, :default => false
    attribute :is_ko
    attribute :death_count, :type => DataType::Integer, :default => 0
    attribute :dead, :type => DataType::Boolean, :default => false

    reference :rider, 'AresMUSH::Combatant'
    collection :passengers, 'AresMUSH::Combatant', :passenger_on

    before_delete :delete_damage

    def delete_damage
      self.damage.each { |d| d.delete }
    end

    def is_mount?
      true
    end

    ## MOUNT STATS & GEAR
    def default_weapon
      Global.read_config("expandedmounts", self.expanded_mount_type, "weapons" ).first
    end

    def weapon
      self.bonded.combatant.weapon
    end

    def armor
      specials = self.armor_specials || []
      special_text = specials.empty? ? nil : "+#{specials.join("+")}"
      "#{self.armor_name}#{special_text}"
    end


    def default_armor
      Global.read_config("expandedmounts", self.expanded_mount_type, "armor" )
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

    ## MISC COMBAT

    def is_noncombatant?
      !self.is_in_combat?
    end

    def is_in_combat?
      !!combat
    end

    def log(msg)
      self.combat.log(msg)
    end

    def roll_ability(ability, mod = 0)

      #probably put methods here to determine reflexes, etc
      self.bonded.combatant.roll_ability(ability, mod)
    end

    def combatant_type
      self.expanded_mount_type
    end

    ## DAMAGE AND HEALING

    def doctors
      Healing.find(patient_id: self.id).map { |h| h.character }
    end

    def inflict_damage(severity, desc, is_stun = false, is_crew_hit = false)
      FS3Combat.inflict_damage(self, severity, desc, is_stun, !self.combat.is_real)
    end

      ## A MOUNT'S MODS, SHIELDS, AND STANCE ARE THE SAME AS THEIR BONDED'S
    def stance
      self.bonded.combatant.stance
    end

    def magic_shields
      self.bonded.magic_shields
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

    def is_passing?
      self.bonded.combatant.is_passing?
    end

    def damage_lethality_mod
      self.bonded.combatant.damage_lethality_mod
    end

    ## STRESS TO A MOUNT TRANSFERS TO THEIR BONDED
    def add_stress(num)
      self.bonded.combatant.add_stress(num)
    end

    ## DEFINED AS A DEFAULT VALUE SO COMBAT WON'T BREAK. THESE SHOULD NOT CHANGE.

    def riding_in
      false
    end

    def is_in_vehicle?
      false
    end

    def vehicle
      nil
    end

    def is_npc?
      false
    end

    def npc
      false
    end

    def magic_item_equipped
      "None"
    end

    def mount_type
      #Do NOT give this a value, it fucks with vanilla mount code.
    end

    def associated_model
      self
    end

    def combatant
      self
    end

  end
end
