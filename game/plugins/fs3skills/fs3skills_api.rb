module AresMUSH
  
  class Character
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
  
  module FS3Skills
    class RollParams
      
      attr_accessor :ability, :modifier, :linked_attr
      
      def initialize(ability, modifier = 0, linked_attr = nil)
        self.ability = ability
        self.modifier = modifier
        self.linked_attr = linked_attr
      end
    
      def to_s
        "#{self.ability} mod=#{self.modifier} linked_attr=#{self.linked_attr}"
      end
    end
    
    module Api

      # Makes an ability roll and returns a hash with the successes and success title.
      # Good for automated systems where you only care about the final result and don't need
      # to know the raw die roll.
      def self.one_shot_roll(client, char, roll_params)
        FS3Skills.one_shot_roll(client, char, roll_params)
      end
      
      # Rolls a raw number of dice.
      def self.one_shot_die_roll(dice)
        FS3Skills.one_shot_die_roll(dice)
      end
      
      def self.app_review(char)
        FS3Skills.app_review(char)
      end
      
      def self.ability_rating(char, ability)
        FS3Skills.ability_rating(char, ability)
      end
      
      # Dice they roll, including related attribute
      def self.dice_rolled(char, ability)
        FS3Skills.dice_to_roll_for_ability(char, RollParams.new(ability))
      end
      
      def self.skills_census(skill_type)
        FS3Skills.skills_census skill_type
      end
    end
  end
end