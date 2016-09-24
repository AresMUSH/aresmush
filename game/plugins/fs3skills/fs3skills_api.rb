module AresMUSH
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
      
      def self.luck(char)
        char.luck
      end
      
      # Does not save!  Must do that yourself!
      def self.award_luck(char, amount)
        FS3Skills.modify_luck(char, amount)
      end
      
      # Does not save!  Must do that yourself!
      def self.spend_luck(char, amount)
        FS3Skills.modify_luck(char, -amount)
      end
      
      def self.xp(char)
        char.xp
      end
    end
  end
end