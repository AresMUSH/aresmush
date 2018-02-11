module AresMUSH
  class Npc < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :name_upcase
    attribute :level, :default => "Goon"

    collection :damage, "AresMUSH::Damage"
    reference :combat, "AresMUSH::Combat"
    
    before_save :save_upcase
    before_delete :clear_damage
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : ""
    end
    
    def clear_damage
      self.damage.each { |d| d.delete }
    end
    
    def roll_ability(ability, mod = 0)
      rating = self.ability_rating(ability)
      Global.logger.info "#{self.name} rolling #{ability} skill=#{rating} mod=#{mod}"
      FS3Skills.one_shot_die_roll(rating + mod)
    end
    
    def ability_rating(ability)
      stats = FS3Combat.npc_type(self.level)
      stats[ability] || stats["Default"]   
    end
    
    def wound_modifier
      self.ability_rating("Wounds") || 0
    end
  end
end