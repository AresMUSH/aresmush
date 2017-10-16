module AresMUSH
  class Character
    attribute :fs3_xp, :type => DataType::Integer, :default => 0
    attribute :fs3_luck, :type => DataType::Float, :default => 1
    
    collection :fs3_attributes, "AresMUSH::FS3Attribute"
    collection :fs3_action_skills, "AresMUSH::FS3ActionSkill"
    collection :fs3_background_skills, "AresMUSH::FS3BackgroundSkill"
    collection :fs3_languages, "AresMUSH::FS3Language"
    collection :fs3_hooks, "AresMUSH::FS3RpHook"
    
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
      FS3Skills.one_shot_roll(nil, self, FS3Skills::RollParams.new(ability, mod))
    end
  end
  
  module LearnableAbility
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
    module ClassMethods
      def register_data_members
        attribute :last_learned, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
        attribute :xp, :type => Ohm::DataTypes::DataType::Integer, :default => 0
      end
    end
    
    def learn
      update(last_learned: Time.now)
      update(xp: self.xp + 1)
    end
    
    def xp_needed
      FS3Skills.xp_needed(self.name, self.rating)
    end
    
    def learning_complete
      self.xp >= self.xp_needed
    end
    
    def can_learn?
      self.time_to_next_learn <= 0
    end
    
    def time_to_next_learn
      return 0 if !self.last_learned
      time_left = (FS3Skills.days_between_learning * 86400) - (Time.now - self.last_learned)
      [time_left, 0].max
    end
  end
  
  
  class FS3Attribute < Ohm::Model
    include ObjectModel
    include LearnableAbility
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    
    index :name
    
    def print_rating
      case rating
      when 0
        return ""
      when 1
        return "%xg@%xn"
      when 2
        return "%xg@@%xn"
      when 3
        return "%xg@@%xy@%xn"
      when 4
        return "%xg@@%xy@@%xn"
      when 5
        return "%xg@@%xy@@%xr@%xn"
      end
    end
    
    def rating_name
      case rating
      when 0 
        return ""
      when 1
        return t('fs3skills.poor_rating')
      when 2
        return t('fs3skills.average_rating')
      when 3
        return t('fs3skills.good_rating')
      when 4
        return t('fs3skills.great_rating')
      when 5
        return t('fs3skills.exceptional_rating')
      end
    end
  end
  
  class FS3ActionSkill < Ohm::Model
    include ObjectModel
    include LearnableAbility
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :specialties, :type => DataType::Array, :default => []
    index :name
    
    def print_rating
      case rating
      when 0
        return ""
      when 1
        return "%xg@%xn"
      when 2
        return "%xg@@%xn"
      when 3
        return "%xg@@%xy@%xn"
      when 4
        return "%xg@@%xy@@%xn"
      when 5
        return "%xg@@%xy@@%xr@%xn"
      when 6
        return "%xg@@%xy@@%xr@@%xn"
      when 7
        return "%xg@@%xy@@%xr@@%xb@%xn"
      when 8
        return "%xg@@%xy@@%xr@@%xb@@%xn"
      end
    end
    
    def rating_name
      case rating
      when 1
        return t('fs3skills.everyman_rating')
      when 2
        return t('fs3skills.fair_rating')
      when 3
        return t('fs3skills.competent_rating')
      when 4
        return t('fs3skills.good_rating')
      when 5
        return t('fs3skills.great_rating')
      when 6
        return t('fs3skills.exceptional_rating')
      when 7
        return t('fs3skills.amazing_rating')
      when 8
        return t('fs3skills.legendary_rating')
      end
    end
  end
  
  class FS3BackgroundSkill < Ohm::Model
    include ObjectModel
    include LearnableAbility
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    
    index :name
    
    def print_rating
      rating_name
    end
    
    def rating_name
      case rating
      when 0
        return t('fs3skills.everyman_rating')
      when 1
        return t('fs3skills.fair_rating')
      when 2
        return t('fs3skills.good_rating')
      when 3
        return t('fs3skills.exceptional_rating')
      end
    end
  end
  
  class FS3Language < Ohm::Model
    include ObjectModel
    include LearnableAbility
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    
    index :name
    
    def print_rating
      rating_name
    end
    
    def rating_name
      case rating
      when 0
        return t('fs3skills.everyman_rating')
      when 1
        return t('fs3skills.beginner_rating')
      when 2
        return t('fs3skills.conversational_rating')
      when 3
        return t('fs3skills.fluent_rating')
      end
    end
  end
  
  class FS3RpHook < Ohm::Model
    include ObjectModel

    index :name
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :description
  end  
  
end