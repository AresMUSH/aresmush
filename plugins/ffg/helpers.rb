module AresMUSH
  module Ffg
    
    def self.is_valid_career?(career)
      return false if !career
      careers = Global.read_config("ffg", "careers").map { |c| c['name'].downcase }
      careers.include?(career.downcase)
    end
    
    def self.is_valid_archetype?(type)
      return false if !type
      types = Global.read_config("ffg", "archetypes").map { |c| c['name'].downcase }
      types.include?(type.downcase)
    end
    
    def self.is_valid_specialization?(spec)
      return false if !spec
      specs = Global.read_config("ffg", "specializations").map { |c| c['name'].downcase }
      specs.include?(spec.downcase)
    end
    
    def self.use_force?
      Global.read_config('ffg', 'use_force')
    end
    
    def self.is_valid_characteristic_name?(name)
      return false if !name
      names = Global.read_config('ffg', 'characteristics').map { |a| a['name'].downcase }
      names.include?(name.downcase)
    end
    
    def self.is_valid_skill_name?(name)
      return false if !name
      names = Global.read_config('ffg', 'skills').map { |a| a['name'].downcase }
      names.include?(name.downcase)
    end
    
    def self.can_manage_abilities?(actor)
      return false if !actor
      actor.has_permission?("manage_apps")
    end
    
    def self.check_max_starting_rating(rating, config_setting)
      max_rating = Global.read_config("ffg", config_setting)
      return nil if rating <= max_rating
      return t('ffg.starting_rating_limit', :rating => max_rating)
    end
    
    def self.skill_rating(char, ability_name)
      skill = Ffg.find_skill(char, ability_name)
      skill ? skill.rating : 0
    end
    
    def self.characteristic_rating(char, ability_name)
      charac = Ffg.find_characteristic(char, ability_name)
      charac ? charac.rating : 0
    end
    
    def self.find_characteristic(char, ability_name)
      name_downcase = ability_name.downcase
      char.ffg_characteristics.select { |a| a.name.downcase == name_downcase }.first
    end
    
    def self.find_skill(char, ability_name)
      name_downcase = ability_name.downcase
      char.ffg_skills.select { |a| a.name.downcase == name_downcase }.first
    end
    
    def self.find_talent(char, ability_name)
      name_downcase = ability_name.downcase
      char.ffg_talents.select { |a| a.name.downcase == name_downcase }.first
    end    
        
    def self.find_talent_config(ability_name)
      return nil if !ability_name
      assets = Global.read_config('ffg', 'talents')
      assets.select { |a| a['name'].downcase == ability_name.downcase }.first
    end

    def self.find_skill_config(name)
      return nil if !name
      types = Global.read_config('ffg', 'skills')
      types.select { |a| a['name'].downcase == name.downcase }.first
    end    
    
    def self.find_archetype_config(name)
      return nil if !name
      types = Global.read_config('ffg', 'archetypes')
      types.select { |a| a['name'].downcase == name.downcase }.first
    end

    def self.find_career_config(name)
      return nil if !name
      careers = Global.read_config('ffg', 'careers')
      careers.select { |a| a['name'].downcase == name.downcase }.first
    end
    
    def self.find_specialization_config(name)
      return nil if !name
      specs = Global.read_config('ffg', 'specializations')
      specs.select { |a| a['name'].downcase == name.downcase }.first
    end
    
    def self.specializations_for_career(career)
      specs = Global.read_config('ffg', 'specializations')
      specs.select { |s| !s['career'].blank? && s['career'].downcase == career.downcase }
    end
    
    def self.universal_specializations
      specs = Global.read_config('ffg', 'specializations')
      specs.select { |s| s['career'].blank? }
    end
    
    def self.set_characteristic(char, ability_name, rating)
      charac = Ffg.find_characteristic(char, ability_name)
      
      if (charac && rating < 1)
        charac.delete
        return
      end
      
      if (charac)
        charac.update(rating: rating)
      else
        FfgCharacteristic.create(name: ability_name, rating: rating, character: char)
      end
      
      if (!char.is_approved?)
        Ffg.update_thresholds(char)
      end
    end
    
    def self.set_skill(char, ability_name, rating)
      skill = Ffg.find_skill(char, ability_name)
      if (skill && rating < 1)
        skill.delete
        return
      end
      
      if (skill)
        skill.update(rating: rating)
      else
        FfgSkill.create(name: ability_name, rating: rating, character: char)
      end
    end
    
    
    def self.is_force_user?(char)
      return false if !Ffg.use_force?
      return false if !char
      return char.ffg_specializations && char.ffg_specializations.any? { |s| Ffg.is_force_spec?(s) }
    end 
    
    def self.is_force_spec?(spec)
      config = Ffg.find_specialization_config(spec)
      config['force_user']
    end
    
    def self.update_thresholds(char)
      return if char.is_approved?
      config = Ffg.find_archetype_config(char.ffg_archetype)
      brawn = Ffg.find_characteristic(char, Global.read_config('ffg', 'wound_characteristic'))
      will = Ffg.find_characteristic(char, Global.read_config('ffg', 'strain_characteristic'))
      wound = config['wound'] + (brawn ? brawn.rating : 0)
      strain = config['strain'] + (will ? will.rating : 0)
      
      char.update(ffg_wound_threshold: wound)
      char.update(ffg_strain_threshold: strain)
      
    end
    
    def self.is_career_skill?(char, skill)
      char.ffg_specializations.each do |spec|
        config = Ffg.find_specialization_config(spec)
        career_skills = config['career_skills'] || []
        return true if career_skills.include?(skill)
      end
      config = Ffg.find_career_config(char.ffg_career)
      return false if !config
      career_skills = config['career_skills'] || []
      return career_skills.include?(skill)
    end
    
    def self.is_career_specialization?(char, spec)
      config = Ffg.find_specialization_config(spec)
      career = config['career']
      !career || (career == char.ffg_career)
    end
  end
end