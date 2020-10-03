module AresMUSH
	module Swrifts
 
		## ----- Init
		

		
		
		## ----- Iconicf
 
		def self.is_valid_iconicf_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'iconicf').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end

		def self.find_iconicf_config(name)
			return nil if !name
			types = Global.read_config('swrifts', 'iconicf')
			types.select { |a| a['name'].downcase == name.downcase }.first
		end

		def self.find_iconicf(model, iconicf_name)
		  name_downcase = iconicf_name.downcase
		  model.swrifts_iconicf.select { |a| a.name.downcase == name_downcase }.first
		end
	 
		def self.get_iconicf(char, iconicf_name)
			charac = Swrifts.find_iconicf_config(iconicf_name)
		end

		def self.set_iconicf_name(char, iconicf_name, enactor)
			char.update(swrifts_iconicf: iconicf_name)
		end
		
		def self.iconicf_value(char)
			field = "iconicf"
			value = Swrifts.find_iconicf_value(char, field)
			value ? value.rating : 0
		end

		def self.find_iconicf_value(char) 
			name = "iconicf"
			char.swrifts_traits.select { |a| a.name.downcase == name_downcase }.first
		end

		## ----- Race
	 
	    def self.is_valid_race_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'races').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end

		def self.find_race_config(name)
			return nil if !name
			types = Global.read_config('swrifts', 'races')
			types.select { |a| a['name'].downcase == name.downcase }.first
		end

		def self.get_race(char, race_name)
			charac = Swrifts.find_race_config(race_name)
		end
	 
		def self.set_race_name(char, race_name, enactor)
			char.update(swrifts_race: race_name)
		end
		
		## ----- Stats
		
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

		def self.find_stat(char, stat_name)
			name_downcase = stat_name.downcase
			char.swrifts_stats.select { |a| a.name.downcase == name_downcase }.first
		end

		## ----- Points
		
		def self.point_rating(char, points_name)
			point = Swrifts.find_points(char, points_name)
			point ? point.rating : 0
		end

		def self.find_points(char, points_name)
			name_downcase = points_name.downcase
			char.swrifts_chargenpoints.select { |a| a.name.downcase == name_downcase }.first
		end

		## ----- Skills

		def self.find_skill(char, skill_name) 
			name_downcase = skill_name.downcase
			char.swrifts_skills.select { |a| a.name.downcase == name_downcase }.first
		end
		
		def self.skill_rating(char, skill_name)
			skill = Swrifts.find_skill(char, skill_name)
			skill ? skill.rating : 0
		end
		
		## ----- Chargen Points

		def self.find_chargen_points(char, point_name) 
			name_downcase = point_name.downcase
			char.swrifts_chargenpoints.select { |a| a.name.downcase == name_downcase }.first
		end
		
		def self.chargen_points_rating(char, point_name)
			points = Swrifts.find_chargen_points(char, point_name)
			points ? points.rating : 0
		end
		
		## ----- Counters

		def self.find_counters(char, counter_name) 
			name_downcase = counter_name.downcase
			char.swrifts_counters.select { |a| a.name.downcase == name_downcase }.first
		end
		
		def self.counters_rating(char, counter_name)
			counters = Swrifts.find_counters(char, counter_name)
			counters ? counters.rating : 0
		end

		## ----- Traits
		
		def self.find_traits(model, iconicf_title)
			name_downcase = iconicf_title.downcase
			model.swrifts_traits.select { |a| a.name.downcase == name_downcase }.first
		end
		
		def return_trait_value(char, traitname)
		traitname = traitname.downcase
		swriftstraits = char.swrifts_traits
		txtstring = ''
		swriftstraits.to_a.sort_by { |a| a.name }
			.each_with_index
				.map do |a, i| 
				if a.name.downcase == "#{traitname}"
					return ("#{a.rating}")
				end
			end	
		end
		
		## ----- Die Step
		
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
		

		# def self.chargen_points(char, points_name) # Aliana, stats_points
			# name_downcase = points_name.downcase
			# swriftschargen_points = char.swrifts_chargen_points
			# swriftschargen_points.to_a.sort_by { |a| a.name }
			# .each_with_index
				# .map do |a, i| 
				# if a.name.downcase == "#{name_downcase}"
					# return a.rating
				# end
			# end	
		# end
  

		
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