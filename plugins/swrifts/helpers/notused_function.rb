module AresMUSH
	module Swrifts
		
				


		# def self.counters_rating(char, counter_name)
			# char.swrifts_counters.select { |a| a.name.downcase == name_downcase }.first
			# counters ? counters.rating : 0
		# end

		

		
		
		## ----- Add Rating
		
		# def self.modify_rating(model, collection, point_name, mod)
			# current_rating = Swrifts.points_rating(model, point_name).to_i
			# new_rating = current_rating + mod
			# points = Swrifts.find_points(model, point_name)				
			# points.update(rating: new_rating)
		# end


		
		# def self.find_points(char, collection, point_name) 
			# char.swrifts_chargenpoints.select { |a| a.name.downcase == name_downcase }.first
		# end
		


			
			
## ----- Generic Set Update with Rating
		# def self.set_update(model, set, element, rating)
			# if (set[element])
				# set_element = set[element]
				# system_counters.each do |key, rating|
					# counter_name = "#{key}".downcase
					# mod = "#{rating}".to_i
					# current_rating = Swrifts.counters_rating(model, counter_name).to_i
					# new_rating = current_rating + mod
					# counters = Swrifts.find_counters(model, counter_name)				
					# counters.update(rating: new_rating)
				# end
			# else 
			# end
		# end

		

		


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
		
		# def self.find_iconicf(model, iconicf_name)
		  # name_downcase = iconicf_name.downcase
		  # model.swrifts_iconicf.select { |a| a.name.downcase == name_downcase }.first
		# end

		# def self.iconicf_value(char)
			# field = "iconicf"
			# value = Swrifts.find_iconicf_value(char, field)
			# value ? value.rating : 0
		# end

		# def self.find_iconicf_value(char) 
			# name = "iconicf"
			# char.swrifts_traits.select { |a| a.name.downcase == name_downcase }.first
		# end
	end
end