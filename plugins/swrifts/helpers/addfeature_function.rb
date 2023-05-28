module AresMUSH
	module Swrifts


		## ----- Features

		def self.add_feature(model, collection, system, system_name)
			# model - Aliana
			# collection - SwriftsEdges
			# system - "edges"
			# system_name - testhind
			collection.create(name: system_name, character: model)
			system_name = system_name.downcase
			#return (system_name.inspect)
			system_name = system_name.gsub("*", "")	 #remove the * that appear in the feature name
			system_name = system_name.gsub("^", "")	 #remove the ^ that appear in the feature name
			systemhash = Global.read_config('swrifts', system) #the whole System from the yml
			# return (systemhash.inspect)
			#return (system_name)
			newsh = systemhash.select { |a| a['name'].to_s != '' } #the whole System minus empty entries
		  	#return (newsh)
			group = newsh.select { |a| a['name'].downcase == system_name.downcase }.first #the whole Group
			#return ( group.inspect );
			if (!group) #If the feature has been entered incorrectly in the yml file, do nothing with it.
				return
			end

			if (group['stats'])
				set=group['stats']
				#return (set.inspect) # "Strength"=>-2, "Agility"=>-2
				charhash = model.swrifts_stats
				#return (charhash.inspect)
				ss = Swrifts.element_update(model, set, charhash)
				#return (ss.inspect)
			else

			end

			if (group['chargen_points'])
				set=group['chargen_points']
				charhash = model.swrifts_chargenpoints
				Swrifts.element_update(model, set, charhash)
			else

			end

			if (group['dstats'])
				set=group['dstats']
				charhash = model.swrifts_dstats
				Swrifts.element_update(model, set, charhash)
			else

			end

			if (group['counters'])
				set=group['counters']
				charhash = model.swrifts_counters
				if (set) #is there an element to update?
					ss = Swrifts.element_update(model, set, charhash)
				end
				# return (ss.inspect)
			else

			end

			if (group['skills'])
				set=group['skills']
				charhash = model.swrifts_skills
				system = SwriftsSkills
				#return (system.inspect)
				ss = Swrifts.element_create(model, set, system)
			else

			end

		end

	end
end
