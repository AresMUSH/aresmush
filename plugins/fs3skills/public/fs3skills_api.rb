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
    
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("fs3skills")
    end
    
    
    # Makes an ability roll and returns a hash with the successes and success title.
    # Good for automated systems where you only care about the final result and don't need
    # to know the raw die roll.
    def self.one_shot_roll(char, roll_params)
      roll = FS3Skills.roll_ability(char, roll_params)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
      
    # Rolls a raw number of dice.
    def self.one_shot_die_roll(dice)
      roll = FS3Skills.roll_dice(dice)
      roll_result = FS3Skills.get_success_level(roll)
      success_title = FS3Skills.get_success_title(roll_result)

      Global.logger.info "Rolling raw dice=#{dice} result=#{roll}"
      
      {
        :successes => roll_result,
        :success_title => success_title
      }
    end
      
    
    def self.app_review(char)
      text = FS3Skills.total_point_review(char)
      text << "%r"
      text << FS3Skills.ability_rating_review(char)
      text << "%r"
      text << FS3Skills.backgrounds_review(char)
      text << "%r%r"
      text << FS3Skills.starting_language_review(char)
      text << "%r"
      text << FS3Skills.starting_skills_check(char)
      text << "%r"
      text << FS3Skills.unusual_skills_check(char)
      text
    end
    
    def self.ability_rating(char, ability_name)
      ability = FS3Skills.find_ability(char, ability_name)
      ability ? ability.rating : 0
    end
    
    # Dice they roll, including related attribute
    def self.dice_rolled(char, ability)
      FS3Skills.dice_to_roll_for_ability(char, RollParams.new(ability))
    end    
    
    def self.skills_census(skill_type)
      skills = {}
      Chargen.approved_chars.each do |c|
        
        if (skill_type == "Action")
          c.fs3_action_skills.each do |a|
            add_to_hash(skills, c, a)
          end

        elsif (skill_type == "Background")
          c.fs3_background_skills.each do |a|
            add_to_hash(skills, c, a)
          end

        elsif (skill_type == "Language")
          c.fs3_languages.each do |a|
            add_to_hash(skills, c, a)
          end
        else
          raise "Invalid skill type selected for skill census: #{skill_type}"
        end
      end
      skills = skills.select { |name, people| people.count > 2 }
      skills = skills.sort_by { |name, people| [0-people.count, name] }
      skills
    end
    
    def self.save_char(char, chargen_data)      
      (chargen_data[:fs3][:fs3_attributes] || []).each do |k, v|
        error = FS3Skills.set_ability(char, k, v.to_i)
        return t('fs3skills.error_saving_ability', :name => k, :error => error) if error
      end

      (chargen_data[:fs3][:fs3_action_skills] || []).each do |k, v|
        error = FS3Skills.set_ability(char, k, v.to_i)
        return t('fs3skills.error_saving_ability', :name => k, :error => error) if error
        
        ability = FS3Skills.find_ability(char, k)
        if (ability)
          specs = (chargen_data[:fs3][:fs3_specialties] || {})[k] || []
          ability.update(specialties: specs)
        end
      end
    
      (chargen_data[:fs3][:fs3_backgrounds] || []).each do |k, v|
        error = FS3Skills.set_ability(char, k, v.to_i)
        return t('fs3skills.error_saving_ability', :name => k, :error => error) if error
      end
    
      (chargen_data[:fs3][:fs3_languages] || []).each do |k, v|
        error = FS3Skills.set_ability(char, k, v.to_i)
        return t('fs3skills.error_saving_ability', :name => k, :error => error) if error
      end
    
      (chargen_data[:fs3][:fs3_advantages] || []).each do |k, v|
        error = FS3Skills.set_ability(char, k, v.to_i)
        return t('fs3skills.error_saving_ability', :name => k, :error => error) if error
      end
      return nil
    end
    
    def self.luck_for_scene(char, scene)
      luck_for_scene = 0
      luck_tracker = char.fs3_scene_luck
      luck_config = Global.read_config('fs3skills', 'luck_for_scene') || {}
      regular_luck = luck_config[0] || 0.1
      
      scene.participants.each do |p|
        next if p == char
        
        days_old = (Time.now - p.created_at) / 86400
        # First-Time RP Bonus
         if (!luck_tracker.has_key?(p.id))
          luck_tracker[p.id] = 1
          # Newbie Bonus
          if (days_old < 30)
            luck_for_scene += regular_luck * 3
          else
            luck_for_scene += regular_luck * 2
          end
        # Diminising returns for the same person
        else
          num_scenes = luck_tracker[p.id]
          luck_for_participant = regular_luck
          luck_config.each do |scene_threshold, luck|
            if (num_scenes > scene_threshold)
              luck_for_participant = luck
            end
          end
          luck_for_scene += luck_for_participant
          luck_tracker[p.id] = luck_tracker[p.id] + 1
        end
      end
      
      if (luck_for_scene > 0)
        char.award_luck(luck_for_scene)
        char.update(fs3_scene_luck: luck_tracker)
      end
    end
  end
end