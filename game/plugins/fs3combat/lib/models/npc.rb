module AresMUSH
  class Npc < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :name_upcase
    attribute :level
    
    before_save :save_upcase
    before_delete :clear_damage
    collection :damage, "AresMUSH::Damage"
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : ""
    end
    
    def clear_damage
      self.damage.each { |d| d.delete }
    end
    
    def roll_ability(ability, mod)
      FS3Skills::Api.one_shot_die_roll(self.skill + mod)
    end
    
    def skill
      case self.level
      when "Goon"
        4
      when "Henchman"
        6
      when "Boss"
        8
      else
        4
      end
    end
  end
end