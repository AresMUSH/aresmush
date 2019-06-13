module AresMUSH
  class Character
    attribute :fs3_xp, :type => DataType::Integer, :default => 0
    attribute :fs3_luck, :type => DataType::Float, :default => 1
    attribute :fs3_cookie_archive, :type => DataType::Integer, :default => 0
    attribute :fs3_scene_luck, :type => DataType::Hash, :default => {}
    
    collection :fs3_attributes, "AresMUSH::FS3Attribute"
    collection :fs3_action_skills, "AresMUSH::FS3ActionSkill"
    collection :fs3_background_skills, "AresMUSH::FS3BackgroundSkill"
    collection :fs3_languages, "AresMUSH::FS3Language"
    collection :fs3_advantages, "AresMUSH::FS3Advantage"    
    
    before_delete :delete_abilities
    
    def delete_abilities
      [ self.fs3_attributes, self.fs3_action_skills, self.fs3_background_skills, self.fs3_languages, self.fs3_advantages].each do |list|
        list.each do |a|
          a.delete
        end
      end
    end
    
    def luck
      self.fs3_luck
    end
    
    def xp
      self.fs3_xp
    end
    
    def award_luck(amount)
      FS3Skills.modify_luck(self, amount)
    end
    
    def spend_luck(amount)
      FS3Skills.modify_luck(self, -amount)
    end
    
    def award_xp(amount)
      FS3Skills.modify_xp(self, amount)
    end
    
    def spend_xp(amount)
      FS3Skills.modify_xp(self, -amount)
    end
    
    def reset_xp
      self.update(fs3_xp: 0)
    end
    
    def roll_ability(ability, mod = 0)
      FS3Skills.one_shot_roll(self, FS3Skills::RollParams.new(ability, mod))
    end
  end
end