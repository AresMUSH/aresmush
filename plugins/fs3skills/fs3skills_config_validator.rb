module AresMUSH
  module FS3Skills
    class FS3SkillsConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("fs3skills")
      end
      
      def validate
        @validator.require_list('action_skills')
        @validator.require_list('advantages')
        @validator.require_list('attributes')
        @validator.require_hash('background_skills')
        @validator.require_list('languages')
        
        @validator.require_nonblank_text('action_skills_blurb')
        @validator.require_nonblank_text('advantages_blurb')
        @validator.require_nonblank_text('attributes_blurb')
        @validator.require_nonblank_text('bg_skills_blurb')
        @validator.require_nonblank_text('language_blurb')
        
        @validator.require_boolean('use_advantages')
        @validator.require_nonblank_text('default_linked_attr')
        @validator.require_int('advantages_cost', 1)
        @validator.require_boolean('allow_incapable_action_skills')
        @validator.require_int('free_backgrounds', 0)
        @validator.require_int('free_languages', 0)
        @validator.require_int('max_ap', 1)
        @validator.require_int('max_attr_rating', 1, 4)
        @validator.require_hash('max_attrs_at_or_above')
        @validator.require_int('max_points_on_action', 0)
        @validator.require_int('max_points_on_attrs', 0)
        @validator.require_int('max_points_on_advantages', 0)
        @validator.require_int('max_points_on_advantages', 0)
        @validator.require_int('max_skill_rating', 1, 8)
        @validator.require_hash('max_skills_at_or_above')
        @validator.require_int('min_backgrounds', 0)
        @validator.require_hash('starting_skills')
        @validator.require_list('unusual_skills')
        @validator.require_hash('luck_for_scene')
        @validator.require_int('max_luck', 1)
        @validator.require_boolean('public_sheets')
        @validator.check_channel_exists('roll_channel')
        @validator.require_int('action_dots_beyond_chargen_max', 0)
        @validator.require_boolean('allow_advantages_xp')
        @validator.require_int('attr_dots_beyond_chargen_max', 0)
        @validator.require_int('advantage_dots_beyond_chargen_max', 0)
        @validator.require_int('days_between_learning', 0)
        @validator.require_int('max_xp_hoard', 0)
        @validator.require_int('periodic_xp', 0)
        @validator.require_hash('xp_costs')
        @validator.check_cron('xp_cron')
        
        begin
          check_attributes
          check_action_skills
          check_advantages
          check_background_skills
          check_languages
          check_xp
          check_misc
          
        rescue Exception => ex
          @validator.add_error "Unknown FS3Skills config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0]}"
        end
        
        @validator.errors
      end
      
      def check_attributes
        abilities = Global.read_config('fs3skills', 'attributes')
        abilities.each do |s|
          name = s['name'] || "Missing Name"
          ['name', 'desc'].each do |prop|
            verify_property_exists(name, s, prop)
          end
          if (FS3Skills.check_ability_name(name))
            @validator.add_error "fs3skills:attributes #{name} cannot contain special characters."
          end
        end
        if (!FS3Skills.attr_names.include?(Global.read_config('fs3skills', 'default_linked_attr')))
          @validator.add_error "fs3skills:default_linked_attr is not a valid attribute."
        end
      end
      
      def check_action_skills
        action_skills = Global.read_config('fs3skills', 'action_skills')
        action_skills.each do |s|
          name = s['name'] || "Missing Name"
          ['name', 'desc', 'linked_attr'].each do |prop|
            verify_property_exists(name, s, prop)
          end
          if (FS3Skills.check_ability_name(name))
            @validator.add_error "fs3skills:action_skills #{name} cannot contain special characters."
          end
          (s['specialties'] || []).each do |spec|
            if (FS3Skills.check_ability_name(spec))
              @validator.add_error "fs3skills:action_skills #{spec} cannot contain special characters."
            end
          end
          if (!FS3Skills.attr_names.include?(s['linked_attr']))
            @validator.add_error "fs3skills:action_skills #{spec} cannot contain special characters."
          end
        end
      end
      
      def check_advantages
        abilities = Global.read_config('fs3skills', 'advantages')
        abilities.each do |s|
          name = s['name'] || "Missing Name"
          ['name', 'desc'].each do |prop|
            verify_property_exists(name, s, prop)
          end
          if (FS3Skills.check_ability_name(name))
            @validator.add_error "fs3skills:advantages #{name} cannot contain special characters."
          end
        end
      end
      
      def check_background_skills
        abilities = Global.read_config('fs3skills', 'background_skills')
        abilities.each do |name, desc|
          if (FS3Skills.check_ability_name(name))
            @validator.add_error "fs3skills:background_skills #{name} cannot contain special characters."
          end
        end
      end
      
      def check_languages
        abilities = Global.read_config('fs3skills', 'languages')
        abilities.each do |s|
          name = s['name'] || "Missing Name"
          verify_property_exists(name, s, 'name')
          if (FS3Skills.check_ability_name(name))
            @validator.add_error "fs3skills:languages #{s['name']} cannot contain special characters."
          end
        end
      end
      
      def check_xp
        xp = Global.read_config('fs3skills', 'xp_costs')
        categories = ['language', 'action', 'background', 'attribute', 'advantage']
        categories.each do |cat|
          if (!xp.keys.include?(cat))
            @validator.add_error "fs3skills:xp_costs is missing category #{cat}."
          end
        end
        
        xp.each do |type, data|
          if (!categories.include?(type))
            @validator.add_error "fs3skills:xp_costs #{type} is not a valid ability category."
          end
          
          data.each do |level, cost|
            if (level.to_i < 0 || level.to_i > 7)
              @validator.add_error "fs3skills:xp_costs #{type} level #{level} is not a valid level."
            end
            if (level.to_i == 0)
              @validator.add_error "fs3skills:xp_costs #{type} level 0->1 always costs 1XP no matter what you put here."
            end
          end
          
        end
      end
      
      def check_misc
        luck_for_scene = Global.read_config('fs3skills', 'luck_for_scene')
        luck_for_scene.each do |scenes, luck|
          if (scenes.to_i < 0)
            @validator.add_error "fs3skills:luck_for_scene #{scenes} is not a valid number of scenes."
          end
          if (!(luck.kind_of?(Integer) || luck.kind_of?(Float)))
            @validator.add_error "fs3skills:luck_for_scene #{luck} is not a valid number of luck points."
          end
        end
        
        max_attrs = Global.read_config('fs3skills', 'max_attrs_at_or_above')
        max_attrs.each do |level, num|
          if (level.to_i == 0)
            @validator.add_error "fs3skills:max_attrs_at_or_above #{level} is not a valid number."
          end

          if (level.to_i < 1 || level.to_i > 4)
            @validator.add_error "fs3skills:max_attrs_at_or_above #{level} must be from 1-4."
          end

          if (num.to_i < 0)
            @validator.add_error "fs3skills:max_attrs_at_or_above #{num} must be greater than 0."
          end
        end

        max_skills = Global.read_config('fs3skills', 'max_skills_at_or_above')
        max_skills.each do |level, num|
          if (level.to_i == 0)
            @validator.add_error "fs3skills:max_skills_at_or_above #{level} is not a valid number."
          end

          if (level.to_i < 1 || level.to_i > 8)
            @validator.add_error "fs3skills:max_skills_at_or_above #{level} must be from 1-8."
          end

          if (num.to_i < 0)
            @validator.add_error "fs3skills:max_skills_at_or_above #{num} must be greater than 0."
          end
        end
        
        start_skills = Global.read_config('fs3skills', 'starting_skills')
        start_skills.each do |name, data|
          if (name == "Everyone")
            validate_starting_skills_list(data['skills'], name)
          else
            group = Demographics.get_group(name)
            if (!group)
              @validator.add_error "fs3skills:starting_skills #{name} is not a valid group."
            end
            data.each do |group_val, group_data|
              validate_starting_skills_list group_data['skills'], name
            end
          end
        end
      end
           
      def validate_starting_skills_list(skills, name)
        if (!skills || !skills.kind_of?(Hash))
          @validator.add_error "fs3skills:starting_skills #{name} is missing a skills list."
        end
      
        skills.each do |skill, rating|
          if (FS3Skills.check_ability_name(skill))
            @validator.add_error "fs3skills:starting_skills #{skill} is an invalid skill name."
          end
          min_rating = Global.read_config("fs3skills", "allow_incapable_action_skills") ? 0 : 1
          if (!rating.kind_of?(Integer) || rating.to_i < min_rating || rating.to_i > 8)
            @validator.add_error "fs3skills:starting_skills #{skill} has an invalid rating."
          end
        end
      end
       
      def verify_property_exists(name, data, prop)
        if (!data[prop])
          @validator.add_error "fs3skills #{name} missing #{prop}." 
        end
      end
      
      
    end
  end
end