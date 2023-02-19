module AresMUSH
	module Swrifts

## ----- Update Char for System
		##	This command is used by the iconicf_set_cmd.rb and race_set_cmd_rb
		##	It is run after the init_function, which sets up the attributes via the create fuction.
		##	It is passed the character model and 'system', which is a named array (the whole 'Shifter' entry in iconicf.yml, for example)
		##	It checks the named array passed to it to see if it has certain groups, such as traits or stats, and updates them.




		def self.run_system(model, system)


			## ----- Update Traits (Rank)
			if (system['traits'])
				system_traits=system['traits']
				system_traits.each do |key, rating|
					trait_name = "#{key}".downcase
					mod = "#{rating}"
					traits = Swrifts.find_traits(model, trait_name)
					traits.update(rating: mod)
				end
			else
			end

			## ----- Update Stats
			if (system['stats'])
				system_stats=system['stats']
				# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
				system_stats.each do |key, rating|
					# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
					stat_name = "#{key}".downcase
					# alias the 'rating' for the same reason and set it to an integer
					mod = "#{rating}".to_i
					# get the current rating of the stat
					current_rating = Swrifts.stat_rating(model, stat_name)
					# add Iconic Framework bonus to Initial stat
					new_rating = current_rating + mod
					stat = Swrifts.find_stat(model, stat_name)
					stat.update(rating: new_rating)
				end
			else
			end

			## ----- Update Chargen Points
			if (system['chargen_points'])
				system_chargen_points=system['chargen_points']
				system_chargen_points.each do |key, rating|
					point_name = "#{key}".downcase
					mod = "#{rating}".to_i
					current_rating = Swrifts.chargen_points_rating(model, point_name).to_i
					new_rating = current_rating + mod
					points = Swrifts.find_chargen_points(model, point_name)
					points.update(rating: new_rating)
					if point_name == 'fandg_slots'
						counter = *(1..mod)
						counter.each do |key|
							setthing = "fandg#{key}"
							fandg_set = model.swrifts_fandg.select { |a| a.name.downcase == setthing }.first
							setdesc = "None"
							fandg_set.update(description: setdesc, character: model)
						end
					else
					end
				end
			else
			end


			## ----- Update Counters
			if (system['counters'])
				system_counters = system['counters']
				system_counters.each do |key, rating|
					counter_name = "#{key}".downcase
					mod = "#{rating}".to_i
					current_rating = Swrifts.counters_rating(model, counter_name).to_i
					new_rating = current_rating + mod
					counters = Swrifts.find_counters(model, counter_name)
					counters.update(rating: new_rating)
				end
			else
			end

			# ----- Add Hinderances to Character -----
			if (system['hinderances'])
				system_hinderances=system['hinderances']
				system_hinderances.each do |key|
					hinderance_name = "#{key}"
					ss = Swrifts.add_feature(model, SwriftsHinderances, "hinderances", hinderance_name)
				end
			else
			end

			dbgstr = ''
			# ----- Add Edges to Character -----
			if (system['edges'])
				system_edges=system['edges']
				system_edges.each do |key|
					edge_name = "#{key}"
					ss = Swrifts.add_feature(model, SwriftsEdges, "edges", edge_name)
					#  dbgstr << "Set:, #{ss}%r"
				end
				#  return dbgstr
			else
			end

			## ----- Update Skills
			if (system['skills'])
				system_skills=system['skills']
				# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
				system_skills.each do |key, rating|
					# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
					skill_name = "#{key}".downcase
					# alias the 'rating' for the same reason and set it to an integer
					mod = "#{rating}".to_i
					# get the current rating of the skill
					current_rating = Swrifts.skill_rating(model, skill_name).to_i
					# add Iconic Framework bonus to Initial skill
					new_rating = current_rating + mod
					# update the collection
					skill = Swrifts.find_skill(model, skill_name)
					if ( !skill )
						skill = 'not found'
					else
						skill.update(rating: new_rating)
					end
				end
			else
			end

			# ----- Adds Magic Powers to the Character -----
			if (system['magic_powers'])
				system_magic_powers=system['magic_powers']
				system_magic_powers.each do |key|
					setthing = "#{key}".downcase
					SwriftsMpowers.create(name: setthing, character: model)
				end
			else
			end

			# ----- Adds Psionic Powers to the Character -----
			if (system['psionic_powers'])
				system_psionic_powers=system['psionic_powers']
				system_psionic_powers.each do |key|
					setthing = "#{key}".downcase
					SwriftsPpowers.create(name: setthing, character: model)
				end
			else
			end

			# ----- Adds Cybernetics to the Character -----
			if (system['cybernetics'])
				system_cybernetics=system['cybernetics']
				system_cybernetics.each do |key|
					setthing = "#{key}".downcase
					SwriftsCybernetics.create(name: setthing, character: model)
				end
			else
			end

			# ----- Adds Abilities to the Character -----
			if (system['abilities'])
				system_abilities=system['abilities']
				system_abilities.each do |key|
					setthing = "#{key}".downcase
					SwriftsAbilities.create(name: setthing, character: model)
				end
			else
			end

			# ----- Adds Complication to the Character -----
			if (system['complications'])
				system_complications=system['complications']
				system_complications.each do |key|
					setthing = "#{key}".downcase
					SwriftsComplications.create(name: setthing, character: model)
				end
			else
			end

			# ----- Create the Hero's Journey slots

			hjcheck = model.swrifts_heroesj.empty?

			if (system['hj1_options']) && hjcheck #See if there are any HJ slots (iconicf command) outlined AND they haven't been set already
				counter = 0
				system.each do | title, value |
					title = title.slice(0,2)
					if title == "hj"
						counter = counter + 1
					else
					end
				end
				counter = *(1..counter)
				counter.each do |key|
					setthing = "hj#{key}"
					setrating = rand(1..10)
					settable = "None"
					setdesc = "None"
					SwriftsHeroesj.create(name: setthing, table: settable, rating: setrating, description: setdesc, character: model)
				end
			elsif (system['hj1_options']) && !hjcheck #See if there are any HJ slots (iconicf command) outlined AND if they already have HJs set up
				counter = 0
				system.each do | title, value |
					title = title.slice(0,2)
					if title == "hj"
						counter = counter + 1
					else
					end
				end
				counter = *(1..counter)
				counter.each do |key|
					setthing = "hj#{key}"
					test = model.swrifts_heroesj
					hj_set = model.swrifts_heroesj.select { |a| a.name.downcase == setthing }.first
					settable = "None"
					setdesc = "None"
					hj_set.update(table: settable, description: setdesc, character: model)
				end
			else
			end

		end
## ----- End Update Char for System
	end
end
