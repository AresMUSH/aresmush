module AresMUSH
	module Swrifts


		## ----- Generic group update
		def self.element_update(model, set, charhash)
			set.each do |key, rating|
				# return (set)
				element_name = "#{key}".downcase
				#return (element_name)
				mod = "#{rating}".to_i
				# return (element_name.inspect)
				element = charhash.select { |a| a.name.downcase == element_name }.first
				return (element.inspect)
				current_rating = element ? element.rating : 0
				new_rating = current_rating + mod
				#return (new_rating)
				element.update(rating: new_rating)
			end
		end

		def self.element_create(model, set, system)
			set.each do |key, rating|
				# return (set)
				element_name = "#{key}".downcase
				# return (element_name)
				mod = "#{rating}".to_i
				system.create(name: element_name, rating: mod, character: model)
			end
		end



		def self.points_rating(char, point_name)
			points = Swrifts.find_points(char, point_name)
			points ? points.rating : 0
		end




		## ----- Iconicf

		def self.is_valid_iconicf_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'iconicf').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end


		def self.trait_set?(model,traitname)
			return false if !model
			return false if !traitname
			chartraits = model.swrifts_traits
			tn = traitname.downcase
			#if (chartraits.size != 0)
			ct = chartraits.select { |a| a.name.downcase == tn }.first
			ctrating = ct.rating.downcase
			if (ctrating)!='none'
				return true
			else
				return false
			end
			#else
				#return true
			#end
		end


		def self.get_iconicf(char, iconicf_name)
			charac = Swrifts.find_iconicf_config(iconicf_name)
		end

		def self.find_iconicf_config(name)
			return nil if !name
			types = Global.read_config('swrifts', 'iconicf')
			types.select { |a| a['name'].downcase == name.downcase }.first
		end


		## ----- Race

	    def self.is_valid_tname?(name, type)
		  return false if !name
		  names = Global.read_config('swrifts', type).map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end

		def self.get_race(char, race_name)
			charac = Swrifts.find_race_config(race_name)
		end

		def self.find_race_config(name)
			return nil if !name
			types = Global.read_config('swrifts', 'races')
			types.select { |a| a['name'].downcase == name.downcase }.first
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

		def self.is_valid_element_name?(element_name)
		  return false if !name
		  names = Global.read_config('swrifts', element_name).map { |a| a['name'].downcase }
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
			name_downcase = points_name.downcase
			point = char.swrifts_chargenpoints.select { |a| a.name.downcase == name_downcase }.first
			point ? point.rating : 0
		end

		def self.find_points(char, points_name)
			name_downcase = points_name.downcase
			char.swrifts_chargenpoints.select { |a| a.name.downcase == name_downcase }.first
		end

		## ----- Skills

		def self.is_valid_skill_name?(name)
		  return false if !name
		  names = Global.read_config('swrifts', 'skills').map { |a| a['name'].downcase }
		  names.include?(name.downcase)
		end

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

		def self.find_traits(model, trait_title)
			name_downcase = trait_title.downcase
			model.swrifts_traits.select { |a| a.name.downcase == name_downcase }.first
		end

		def self.return_element_value(char, element_title, set)
			return ("#{char}, #{element_title}, #{set}")
			element = char.set.select { |a| a.name.downcase == element_title }.first
			element ? element.rating : 0
		end

		## ---- Return all Iconic Frameworks
		def self.swrifts_icf
			Global.read_config('swrifts', 'iconicf')
		end

		## ---- Return all Races
		def self.swrifts_races
			Global.read_config('swrifts', 'races')
		end

		## ---- Return all Edges
		def self.swrifts_edges
			Global.read_config('swrifts', 'edges')
		end

		## ---- Return all Hinderances
		def self.swrifts_hinderances
			Global.read_config('swrifts', 'hinderances')
		end

		## ---- Return all Skills
		def self.swrifts_skills
			Global.read_config('swrifts', 'skills')
		end

		## ---- Return all Powers
		def self.swrifts_powers
			Global.read_config('swrifts', 'ppowers')
		end

		## ---- Return all Abilities
		def self.swrifts_abilities
			Global.read_config('swrifts', 'abilities')
		end


		## ----- Die Step

		def self.rating_to_die( rating )
			rating_num = rating.to_i
			case rating_num
			when -2
				return "d4-4"
			when -1
				return "d4-3"
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

	end
end
