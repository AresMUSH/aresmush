module AresMUSH
  module Swade
    # def self.die_steps
      # [ 'd2', 'd4', 'd6', 'd8', 'd10', 'd12', 'd12+d2', 'd12+d4', 'd12+d6', 'd12+d8', 'd12+d10', 'd12+d12' ]
    # end
 
    def self.is_iconicf_valid_name?(name)
      return false if !name
      names = Global.read_config('swade', 'iconicf').map { |a| a['name'].downcase }
      names.include?(name.downcase)
    end
 
    def self.find_iconicf_config(name)
		return nil if !name
		types = Global.read_config('swade', 'iconicf')
		types.select { |a| a['name'].downcase == name.downcase }.first
    end

    def self.find_iconicf(model, iconicf_name)
      name_downcase = iconicf_name.downcase
      model.swade_iconicf.select { |a| a.name.downcase == name_downcase }.first
    end
 
	def self.get_iconicf(char, iconicf_name)
		charac = Swade.find_iconicf_config(iconicf_name)
	end
 
    def self.is_valid_die_step?(step)
      Swade.die_steps.include?(step)
    end
    
    def self.is_valid_stat_name?(name)
      return false if !name
      names = Global.read_config('swade', 'stats').map { |a| a['name'].downcase }
      names.include?(name.downcase)
    end
    
    def self.can_manage_stats?(actor)
      return false if !actor
      actor.has_permission?("manage_apps")
    end
    
    def self.find_stat(model, stat_name)
      name_downcase = stat_name.downcase
	  model.swade_stats.select { |a| a.name.downcase == name_downcase }.first
    end
  
    # def self.format_die_step(input)
      # return "" if !input
      # input.downcase.gsub(" ", "")
    # end
    
    # def self.find_stat_step(char, stat_name)
      # return nil if !stat_name
      
      # #case stat_name.downcase
      
      # [ char.Swade_stats ].each do |list|
        # found = list.select { |a| a.name.downcase == ability_name.downcase }.first
        # return found.die_step if found
      # end
      # return nil
    # end
    
    # def self.check_max_starting_rating(die_step, config_setting)
      # max_step = Global.read_config("Swade", config_setting)
      # max_index = Swade.die_steps.index(max_step)
      # index = Swade.die_steps.index(die_step)
      
      # return nil if !index
      # return nil if index <= max_index
      # return t('Swade.starting_rating_limit', :step => max_step)
    # end
    
    # def self.points_for_step(die_step)
      # costs = {
        # 'd2' => 1,
        # 'd4' => 2,
        # 'd6' => 3,
        # 'd8' => 4,
        # 'd10' => 5,
        # 'd12' => 6,
      # }

      # costs[die_step] || 0
    # end

  end
end