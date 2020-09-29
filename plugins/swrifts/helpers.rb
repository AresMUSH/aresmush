module AresMUSH
	module Swrifts
 
		def self.is_valid_iconicf_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'iconicf').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end
	 
		 def self.is_valid_race_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'races').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end
	 
		def self.find_iconicf_config(name)
			return nil if !name
			types = Global.read_config('swrifts', 'iconicf')
			types.select { |a| a['name'].downcase == name.downcase }.first
		end

		def self.find_race_config(name)
			return nil if !name
			types = Global.read_config('swrifts', 'races')
			types.select { |a| a['name'].downcase == name.downcase }.first
		end

		def self.find_iconicf(model, iconicf_name)
		  name_downcase = iconicf_name.downcase
		  model.swrifts_iconicf.select { |a| a.name.downcase == name_downcase }.first
		end
	 
		def self.get_iconicf(char, iconicf_name)
			charac = Swrifts.find_iconicf_config(iconicf_name)
		end
		
		def self.get_race(char, race_name)
			charac = Swrifts.find_race_config(race_name)
		end
	 
		def self.set_iconicf_name(char, iconicf_name, enactor)
			char.update(swrifts_iconicf: iconicf_name)
		end
		
		def self.set_race_name(char, race_name, enactor)
			char.update(swrifts_race: race_name)
		end
		
		def self.is_valid_stat_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'stats').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end
		
		def self.can_manage_stats?(actor)
		  return false if !actor
		  actor.has_permission?("manage_apps")
		end
		
		def self.stat_rating(char, stat_name)
			stat = Swrifts.find_stat(char, stat_name)
			stat ? stat.rating : 0
		end
		
		def self.find_stat(char, stat_name) #deleted version with 'model' instead of 'char'
			name_downcase = stat_name.downcase
			char.swrifts_stats.select { |a| a.name.downcase == name_downcase }.first
		end
		
		def self.rating_to_die( rating )
			rating_num = rating.to_i
			case rating_num
			when 0
				return "-"
			when 1
				return "d4"
			when 2
				return "d6"
			when 3
				return "d8"
			when 4
				return "d10"
			when 5
				return "d12"
			else
				step = rating_num - 5
				step_to_string = step.to_s
				die_step = "d12+" 
				return die_step+step_to_string
			end
		end

		def self.chargen_points(char, points_name) # Aliana, stats_points
			points_name = points_name.downcase
			swriftschargen_points = char.swrifts_chargen_points
			swriftschargen_points.to_a.sort_by { |a| a.name }
			.each_with_index
				.map do |a, i| 
				if a.name.downcase == "#{countername}"
					return a.rating
				end
			end	
		end
  

		
		# def self.check_max_starting_rating(die_step, config_setting)
		  # max_step = Global.read_config("Swrifts", config_setting)
		  # max_index = Swrifts.die_steps.index(max_step)
		  # index = Swrifts.die_steps.index(die_step)
		  
		  # return nil if !index
		  # return nil if index <= max_index
		  # return t('Swrifts.starting_rating_limit', :step => max_step)
		# end
		


	end
end