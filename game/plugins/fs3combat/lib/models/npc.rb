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
      Global.logger.info "#{self.name} rolling #{ability} skill=#{skill} mod=#{mod}"
      FS3Skills::Api.one_shot_die_roll(self.skill + mod)
    end
    
    def self.levels
      ["Goon", "Henchman", "Boss"]
    end
    
    def skill
      case self.level
      when "Goon"
        5
      when "Henchman"
        7
      when "Boss"
        9
      else
        5
      end
    end
  end
end