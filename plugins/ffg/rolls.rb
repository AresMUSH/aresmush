module AresMUSH
  module Ffg

    class FfgRollParams
      attr_accessor :boost, :ability, :proficiency, :setback, :difficulty, :challenge, :force, :skill
      
      def initialize
        self.boost = 0
        self.ability = 0
        self.proficiency = 0
        self.setback = 0
        self.difficulty = 0
        self.challenge = 0
        self.force = 0 
        self.skill = nil
      end
    end
    
    class FfgRollResults
      attr_accessor :successful, :net_advantage, :net_threat, :despair, :triumph
    end
    
    # Returns a FfgRollParams object
    def self.parse_roll_string(roll_str)
      params = FfgRollParams.new
      sections = roll_str.split('+')
      sections.each do |s|
        s = s.strip.titlecase
        if (s =~ /([\d]+)b/i)
          params.boost = $1.to_i
        elsif (s =~ /([\d]+)a/i)
          params.ability = $1.to_i
        elsif (s =~ /([\d]+)p/i)
          params.proficiency = $1.to_i
        elsif (s =~ /([\d]+)s/i)
          params.setback = $1.to_i
        elsif (s =~ /([\d]+)d/i)
          params.difficulty = $1.to_i
        elsif (s =~ /([\d]+)c/i)
          params.challenge = $1.to_i
        elsif (s =~ /([\d]+)f/i)
          params.force = $1.to_i
        else
          config = Ffg.find_skill_config(s)
          return nil if !config
          params.skill = s
        end
      end
      params
    end
    
    # Returns a FfgRollResults object
    def self.roll_ability(char, roll_str)
      params = Ffg.parse_roll_string(roll_str)
      return nil if !params
      
      dice = []
      
      if (params.skill)
        skill_dice = Ffg.find_skill_dice(char, params.skill)
        
        params.ability += skill_dice[:ability]
        params.proficiency += skill_dice[:proficiency]
      end
            
      params.boost.times.each do |d|
        dice << Ffg.roll_boost_die
      end
      params.ability.times.each do |d|
        dice << Ffg.roll_ability_die
      end
      params.proficiency.times.each do |d|
        dice << Ffg.roll_proficiency_die
      end
      params.setback.times.each do |d|
        dice << Ffg.roll_setback_die
      end
      params.difficulty.times.each do |d|
        dice << Ffg.roll_difficulty_die
      end
      params.challenge.times.each do |d|
        dice << Ffg.roll_challenge_die
      end
      params.force.times.each do |d|
        dice << Ffg.roll_force_die
      end
      
      Global.logger.info "Rolling #{params.inspect} - #{dice}."
      dice.flatten.sort
    end
    
    def self.find_skill_dice(char, skill)
      skill_rating = Ffg.skill_rating(char, skill)
      charac_rating = Ffg.related_characteristic_rating(char, skill)
      
      if (skill_rating > charac_rating)
        ability_dice = skill_rating - charac_rating
        prof_dice = charac_rating
      else
        ability_dice = charac_rating - skill_rating
        prof_dice = skill_rating
      end
      {
        ability: ability_dice,
        proficiency: prof_dice
      }
    end
    
    def self.related_characteristic_rating(char, skill)
      skill_config = Ffg.find_skill_config(skill)
      return 0 if !skill_config
      Ffg.characteristic_rating(char, skill_config['characteristic'])
    end
      
    def self.determine_outcome(dice)
      successes = dice.select { |d| d == 'S' || d == 'TRI' }.count
      failures = dice.select { |d| d == 'F' || d == 'DES' }.count
      
      adv = dice.select { |d| d == 'A' }.count
      threat = dice.select { |d| d == 'T' }.count
      
      results = FfgRollResults.new
      results.successful = successes > failures
      results.triumph = dice.any? { |d| d == 'TRI' }
      results.despair = dice.any? { |d| d == 'DES' }
      results.net_advantage = adv > threat ? adv - threat : 0
      results.net_threat = threat > adv ? threat - adv : 0
      
      results
    end
    
    def self.special_roll_effects(results)
      special = ""
      
      if (results.net_advantage > 0)
        special << "#{t('ffg.roll_advantage', :net => results.net_advantage)} "
      end
      if (results.net_threat > 0)
        special << "#{t('ffg.roll_threat', :net => results.net_threat)} "
      end
      if (results.triumph)
        special << "#{t('ffg.roll_triumph')} "
      end
      if (results.despair)
        special << "#{t('ffg.roll_despair')} "
      end
      special
    end
    
    def self.roll_boost_die
      [ ['-'], ['-'], ['S'], [ 'S', 'A' ], [ 'A', 'A' ], [ 'A' ] ].shuffle.first
    end
    
    def self.roll_ability_die
      [ ['-'], ['S'], ['S'], [ 'S', 'S' ], [ 'A' ], [ 'A' ], [ 'S', 'A' ], [ 'A', 'A' ] ].shuffle.first
    end
    
    def self.roll_proficiency_die
      [ ['-'], ['S'], ['S'], [ 'S', 'S' ], [ 'S', 'S' ], [ 'A' ], [ 'S', 'A' ], [ 'S', 'A' ], [ 'S', 'A' ], [ 'A', 'A'], [ 'A', 'A' ], [ 'TRI' ]].shuffle.first
    end
    
    def self.roll_setback_die
      [ ['-'], ['-'], ['F'], [ 'F' ], [ 'T' ], [ 'T' ] ].shuffle.first
    end
    
    def self.roll_difficulty_die
      [ ['-'], ['F'], ['F', 'F'], ['T'], [ 'T' ], [ 'T' ], [ 'T', 'T' ], [ 'F', 'T' ] ].shuffle.first
    end
    
    def self.roll_challenge_die
      [ ['-'], ['F'], ['F'], [ 'F', 'F' ], [ 'F', 'F' ], [ 'T' ], [ 'T' ], [ 'F', 'T' ], [ 'F', 'T' ], [ 'T', 'T'], [ 'T', 'T' ], [ 'DES' ]].shuffle.first
    end
    
    def self.roll_force_die
      [ ['Dark'], ['Dark'], ['Dark'], ['Dark'], ['Dark'], ['Dark'], ['Dark', 'Dark'], ['Light'], ['Light'], ['Light', 'Light'], ['Light', 'Light'], ['Light', 'Light'] ].shuffle.first
    end
    
  end
end