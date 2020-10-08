module AresMUSH    
	module Swrifts
		class RaceSetCmd
			include CommandHandler
	  
			attr_accessor :target_name, :race_name, :race_title, :swrifts_race
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.race_name = trim_arg(cmd.args) #Set 'race_name' to be the inputted Race
				self.race_title = "race"
				# self.swrifts_race = "swrifts_race:" 

			end

			def required_args
				[ self.target_name, self.race_name ]
			end
			
  
  			#----- Check to see:
			def check_valid_iconicf
				if !Swrifts.is_valid_tname?(self.race_name, "races") #Is the Race in the list
					return t('swrifts.race_invalid_name', :name => self.race_name.capitalize) 
				# elsif
					# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						# if Swrifts.trait_set?(model,"race") #Is the Race already set
							# return t('swrifts.trait_already_set',:name => "Race")
						# end
					# end
				elsif
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						if !Swrifts.is_valid_cat?(model,"traits") or !Swrifts.trait_set?(model,"iconicf")
							return t('swrifts.use_command',:name => "iconicf")
						end
					end
				end
				return nil
			end
  
  
  
 #----- Begin of def handle -----			 
			def handle
				race = Swrifts.get_race(self.enactor, self.race_name) 


				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					e_iconicf = model.swrifts_iconicf
					icf = ( "#{e_iconicf}" )
				end
				
				# return IconicfSetCmd

				## ----- Update Race Framework
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					trait = Swrifts.find_traits(model, self.race_title)				
					trait.update(rating: self.race_name)
				end

				## ----- Update Stats
				if (race['stats'])
					race_stats=race['stats']
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					race_stats.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						stat_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the stat
						current_rating = Swrifts.stat_rating(enactor, stat_name)
						# add Race bonus to Initial stat
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							stat = Swrifts.find_stat(model, stat_name)				
							stat.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.racestats_set')
				else 
					# If the Race does not have this field in race.yml, skip and emit to enactor
					# client.emit_failure ("This Race has no Stat changes")
				end
				
				## ----- Update Chargen Points
				if (race['chargen_points'])
					race_chargen_points=race['chargen_points']
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					race_chargen_points.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						point_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the skill
						current_rating = Swrifts.chargen_points_rating(enactor, point_name).to_i
						# add Race bonus to Initial skill
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							points = Swrifts.find_chargen_points(model, point_name)				
							points.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.chargen_points_set')
				else 
					# If the Race does not have this field in race.yml, skip and emit to enactor
					# client.emit_failure ("This Race has no Chargen Point changes")
				end
				
				## ----- Update Counters
				if (race['counters'])
					race_counters = race['counters']
					race_counters.each do |key, rating|
						counter_name = "#{key}".downcase
						mod = "#{rating}".to_i
						current_rating = Swrifts.counters_rating(enactor, counter_name).to_i
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							counters = Swrifts.find_counters(model, counter_name)				
							counters.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.counters_set')
				else 
					# If the Race does not have this field in race.yml, skip and emit to enactor
					# client.emit_failure ("This Race has no Counters changes")
				end

				# ----- This sets the default Hinderances on the Character -----	
				if (race['hinderances']) 
					race_hinderances=race['hinderances'] 
					race_hinderances.each do |key|
						hinderance_name = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							ss = Swrifts.add_feature(model, SwriftsHinderances, "hinderances", hinderance_name)
							# client.emit ("hind: #{ss}")
						end
					end
					# client.emit_success t('swrifts.iconichinderances_set')
				else 
					# client.emit_failure ("This Race has no Hinderances")
				end
				
				# ----- This sets the default Edges on the Character -----				
				if (race['edges'])
					race_edges=race['edges'] 
					race_edges.each do |key|
						edge_name = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							ss = Swrifts.add_feature(model, SwriftsEdges, "edges", edge_name)
							# client.emit ("llll: #{ss}")
						end
					end
					# client.emit_success t('swrifts.iconicedges_set')
				else 
					# client.emit_failure ("This Race has no Edges")
				end

				## ----- Update Skills
				if (race['skills'])
					race_skills=race['skills'] 
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					race_skills.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						skill_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the skill
						current_rating = Swrifts.skill_rating(enactor, skill_name).to_i
						# add Race bonus to Initial skill
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							skill = Swrifts.find_skill(model, skill_name)				
							skill.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.iconicskills_set')
				else 
					# If the Race does not have this field in race.yml, skip and emit to enactor
					# client.emit_failure ("This Race has no Skill changes")
				end

				# ----- This sets the default Magic Powers on the Character -----	
				if (race['magic_powers'])
					race_magic_powers=race['magic_powers'] 
					race_magic_powers.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsMpowers.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconicmpowers_set')
				else 
					# client.emit_failure ("This Race has no Magic Powers")
				end 

				# ----- This sets the default Psionic Powers on the Character -----	
				if (race['psionic_powers'])
					race_psionic_powers=race['psionic_powers']
					race_psionic_powers.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsPpowers.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconicppowers_set')
				else 
					# client.emit_failure ("This Race has no Psionic Powers")
				end

				# ----- This sets the default Cybernetics on the Character -----	
				if (race['cybernetics'])
					race_cybernetics=race['cybernetics']
					race_cybernetics.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsCybernetics.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconiccybernetics_set')
				else 
					# client.emit_failure ("This Race has no Cybernetics")
				end
				
				# ----- This sets the default Abilities on the Character -----	
				if (race['abilities'])
					race_abilities=race['abilities'] 
					race_abilities.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsAbilities.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconicabilities_set')
				else 
					# client.emit_failure ("This Race has no Abilities")
				end
				
				# ----- This sets the default Complications on the Character -----
				if (race['complications'])
					race_complications=race['complications'] 
					race_complications.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsComplications.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconiccomplications_set')
				else 
					# client.emit_failure ("This Race has no Complications")
				end
				
				



				client.emit_success t('swrifts.race_complete')
			end
#----- End of def handle -----	
			
		end
	end
end