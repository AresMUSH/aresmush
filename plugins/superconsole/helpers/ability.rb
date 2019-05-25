module AresMUSH
  module SuperConsole

    def self.attrs
      Global.read_config("superconsole", "attributes")
    end

    def self.get_max_default_learn(a)
      type = SuperConsole.get_ability_type(a)
      case type
      when :attribute
        ab = SuperConsole.attrs.find { |s| s['name'].upcase == a.upcase}['max_learn']
      when :ability
        ab = SuperConsole.abilities.find { |s| s['name'].upcase == a.upcase}['max_learn']
      else
        nil
      end
      ab
    end

    def self.get_max_learn_adj(c,a)
      base = SuperConsole.get_max_default_learn(a)
      type = SuperConsole.get_ability_type(a)
      case type
      when :attribute
        base
      else
       arch = c.group("archetype") || "Unknown"
       listing = "#{arch.downcase}_favored"
       favor = Global.read_config("superconsole", "#{listing}").find { |s| s['name'].upcase == a.upcase}
       status = favor['status']
       basemod = Global.read_config("superconsole","favored_modifier") || 0.25
       learnmod = if c.is_quick_learner then 0.5 else 0.0 end
       if (favor) && status == true
        mod = base - (base * (basemod + learnmod))
       else
        mod = base - (base * learnmod)
       end
       mod.floor
     end
    end

    def self.attr_names
      attrs.map { |a| a['name'].titlecase }
    end

    def self.abilities
      Global.read_config("superconsole", "abilities")
    end

    def self.abilities_name
      abilities.map { |a| a['name'].titlecase}
    end

    def self.get_min_rating(ability_type)
      case ability_type
      when :ability
        min_rating = 0
      when :attribute
        min_rating = 1
      end
      min_rating
    end

    def self.set_ability(char, ability_name, rating)
      ability_name = ability_name ? ability_name.titleize : nil
      error = SuperConsole.check_ability_name(ability_name)
      if (error)
        return error
      end
      ability_type = SuperConsole.get_ability_type(ability_name)

      min_rating = SuperConsole.get_min_rating(ability_type)
      ability = SuperConsole.find_ability(char, ability_name)

      if (ability)
        ability.update(rating: rating)
      else
        case ability_type
        when :attribute
          ability = ConsoleAttribute.create(character: char, name: ability_name, rating: rating, masterpoints: 0, learnpoints: 0, learnable: true)
        when :ability
          ability = ConsoleAbility.create(character: char, name: ability_name, rating: rating, masterpoints: 0, learnpoints: 0, learnable: true, learned: false)
        end
      end
      if (rating == min_rating)
        if (ability && (ability_type == :ability))
          ability.delete
        end
      end
      return nil
    end

    def self.check_ability_name(ability)
      return t('SuperConsole.no_special_characters') if (ability !~ /^[\w\s]+$/)
      return nil
    end

    def list_master
      list = {}
      @char.console_skills.each do |ability|
        list[ability.name] = ability.name
        list[ability.rating] = ability.rating
        list[ability.learnpoints] = ability.learnpoints
        list[ability.learnable] = ability.learnable
        list[ability.masterpoints] = ability.masterpoints
      end
      SuperConsole.abilities_name.each do |config|
        list[config[:name]] = config.name
        list[config[:rating]] = 0
        list[config[:learnpoints]] = 0
        list[config[:learnable]] = true
        list[config[:masterpoints]] = 0
     end
  end

    def self.get_ability_type(a)
      ability = a.titlecase
      if (attr_names.include?(ability))
        return :attribute
      elsif (abilities_name.include?(ability))
        return :ability
      else
        nil
      end
    end

    def self.find_ability(char, ability_name)
      ability_name = ability_name.titlecase
      ability_type = SuperConsole.get_ability_type(ability_name)
      case ability_type
      when :attribute
        char.console_attributes.find(name: ability_name).first
      when :ability
        char.console_skills.find(name: ability_name).first
      else
        nil
      end
    end

    def self.ability_rating(char, ability_name)
      ability = SuperConsole.find_ability(char, ability_name)
      ability ? ability.rating : 0
    end
  end
end
