module AresMUSH
  class Character
    attribute :fs3_xp, :type => DataType::Integer, :default => 0
    attribute :fs3_luck, :type => DataType::Float, :default => 1
    attribute :fs3_will, :type => DataType::Float, :default => 0
    attribute :fs3_sanity, :type => DataType::Float, :default => 0

    collection :fs3_attributes, "AresMUSH::FS3Attribute"
    collection :fs3_action_skills, "AresMUSH::FS3ActionSkill"
    collection :fs3_background_skills, "AresMUSH::FS3BackgroundSkill"
    collection :fs3_languages, "AresMUSH::FS3Language"
    collection :fs3_advantages, "AresMUSH::FS3Advantage"
    collection :fs3_magix_arts, "AresMUSH::FS3MagixArt"

    before_delete :delete_abilities

    def delete_abilities
      [ self.fs3_attributes, self.fs3_action_skills, self.fs3_magix_arts, self.fs3_background_skills, self.fs3_languages, self.fs3_advantages].each do |list|
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

    def will
      self.fs3_will
    end

    def sanity
      self.fs3_sanity
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

    def reset_will
      base_will = FS3Skills.get_base_will(self)
      self.update(fs3_will: base_will)
    end

    def reset_sanity
      base_sanity = FS3Skills.get_base_sanity(self)
      self.update(fs3_sanity: base_sanity)
    end

    def get_base_sanity(self)
      grit = FS3Skills.ability_rating(self, "Grit") * 2
      adv = FS3Skills.has_ability(self, "Iron Will")
      adv_rating = adv ? FS3Skills.ability_rating(self, "Iron Will") : 0
      (grit + adv_rating)
    end

    def get_base_sanity(self)
      grit = FS3Skills.ability_rating(self, "Grit")
      comp = FS3Skills.ability_rating(self, "Composure")
      adv = FS3Skills.has_ability(self, "Clarity")
      adv_rating = adv ? FS3Skills.ability_rating(self, "Clarity") : 0
      (grit + adv_rating + comp)
    end

    def roll_ability(ability, mod = 0)
      FS3Skills.one_shot_roll(self, FS3Skills::RollParams.new(ability, mod))
    end
  end
end
