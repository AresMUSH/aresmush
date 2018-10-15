module AresMUSH
  module Fate
    
    def self.rating_ladder
      {
        "Legendary" => 8,
        "Epic" => 7,
        "Fantastic" => 6,
        "Superb" => 5,
        "Great" => 4,
        "Good" => 3,
        "Fair" => 2,
        "Average" => 1,
        "Mediocre" => 0,
        "Poor" => -1,
        "Terrible" => -2
      }
    end
    
    def self.roll_fate_die
      die = [ -1, -1, 0, 0, 1, 1 ].shuffle.first
    end
    
    def self.roll_fate_dice
      dice = []
      4.times.each do |i|
        dice << Fate.roll_fate_die
      end
      total = dice.inject(0){|sum, x| sum + x }

      Global.logger.debug "Rolled fate dice: #{dice} = #{total}"
      total
    end
    
    def self.roll_skill(char, roll_str)
      match = /^(?<ability>[^\+\-]+)\s*(?<modifier>[\+\-]\s*\d+)?$/.match(roll_str)
      return nil if !match

      ability = match[:ability].strip
      modifier = match[:modifier].nil? ? 0 : match[:modifier].gsub(/\s+/, "").to_i
      if Fate.rating_ladder[ability]
        rating = Fate.rating_ladder[ability]
      elsif char
        rating = Fate.skill_rating(char, roll_str)
      else 
        rating = 0
      end
      
      total = Fate.roll_fate_dice + modifier + rating
      Global.logger.debug "Rolling #{roll_str} for #{char.name}: abil=#{ability} mod=#{modifier} rating=#{rating} total=#{total}"
        
      total
    end
    
    def self.can_manage_abilities?(actor)
      return false if !actor
      actor.has_permission?("manage_apps")
    end
        
    def self.name_to_rating(name)
      return nil if !name
      return name.to_i if name.is_integer?
      name = name.titlecase
      if (Fate.rating_ladder.has_key?(name))
        return Fate.rating_ladder[name]
      end
      return nil
    end
    
    def self.is_valid_skill_rating?(rating)
      Fate.rating_ladder.any? { |n, r| r == rating }
    end
    
    def self.skills
      Global.read_config('fate', 'skills')
    end
    
    def self.is_valid_skill_name?(name)
      return true if Fate.skills.any? { |s| s['name'].downcase == name.downcase }
      return true if name.is_integer?
      return false
    end
    
    def self.update_refresh(model)
      num_stunts = (model.fate_stunts || {}).count
      if (num_stunts <= 3)
        model.update(fate_refresh: 3)
      elsif (num_stunts == 4)
        model.update(fate_refresh: 2)
      else
        model.update(fate_refresh: 1)
      end
    end
    
    def self.skill_rating(model, skill)
      model.fate_skills[skill.titlecase] || 0
    end
    
    def self.rating_name(rating)
      if (rating > 8)
        return "Beyond Legendary"
      end
      
      if (rating < -2)
        return "Beyond Terrible"
      end
      
      return Fate.rating_ladder.key(rating)
    end
    
    def self.physical_stress_thresh(model)
      skill = Global.read_config('fate', 'physical_stress_skill')
      skill_rating = Fate.skill_rating(model, skill)
      if (skill_rating == 1 || skill_rating == 2)
        return 3
      elsif (skill_rating >= 3)
        return 4
      else
        return 2
      end
    end
    
    def self.mental_stress_thresh(model)
      skill = Global.read_config('fate', 'mental_stress_skill')
      skill_rating = Fate.skill_rating(model, skill)
      if (skill_rating == 1 || skill_rating == 2)
        return 3
      elsif (skill_rating >= 3)
        return 4
      else
        return 2
      end
    end
    
    def self.refresh_fate
      Chargen.approved_chars.each { |c| c.update(fate_points: fate_refresh) }
    end
  end
end