module AresMUSH
  module FS3Skills
    
    class RollParams
      
      attr_accessor :ability, :modifier, :related_apt
      
      def initialize(ability, modifier = 0, related_apt = nil)
        self.ability = ability
        self.modifier = modifier
        self.related_apt = related_apt
      end
    
      def to_s
        "#{self.ability} mod=#{self.modifier} related_apt=#{self.related_apt}"
      end
    end
    
    module Interface

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
    end
  end
end