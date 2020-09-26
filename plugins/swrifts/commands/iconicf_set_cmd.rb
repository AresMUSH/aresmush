module AresMUSH    
	module Swrifts
		class IconicfSetCmd
			include CommandHandler
			      
			attr_accessor :target, :iconicf_name, :swrifts_iconicf
			
			def parse_args
				self.target = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.swrifts_iconicf = "swrifts_iconicf:" 

			end

			def required_args
				[ self.target, self.iconicf_name ]
			end
			
			#----- Check to see if what was entered was an Iconic Framework in game\config\swrifts_iconicf.yml
			def check_valid_iconicf
				return t('swrifts.iconicf_invalid_name', :name => self.iconicf_name.capitalize) if !Swrifts.is_valid_iconicf_name?(self.iconicf_name)
				return nil
			end
#----- Begin of def handle -----			
			def handle  
				# sets 'iconicf' to the Iconic Framework 'name' of our game\config\swrifts_iconicf.yml file
				iconicf = Swrifts.get_iconicf(self.enactor, self.iconicf_name) 
				# sets 'iconicf_bennies' to the number of Bennies in game\config\swrifts_iconicf.yml file
				iconicf_bennies = Swrifts.get_iconicf(self.enactor, self.iconicf_swrifts_bennies)
				# pulls out the 'stats' portion of the named Iconic Framework into a list
				iconicf_stats=iconicf['stats']  
				# pulls out the 'skills' portion of the named Iconic Framework into a list
				iconicf_skills=iconicf['skills'] 
				# pulls out the 'hinderances' portion of the named Iconic Framework into a list
				iconicf_hinderances=iconicf['hinderances'] 
				# pulls out the 'edges' portion of the named Iconic Framework into a list
				iconicf_edges=iconicf['edges'] 
				# pulls out the 'abilities' portion of the named Iconic Framework into a list
				iconicf_abilities=iconicf['abilities'] 
				# pulls out the 'complications' portion of the named Iconic Framework into a list
				iconicf_complications=iconicf['complications'] 
				# pulls out the 'magic_powers' portion of the named Iconic Framework into a list
				iconicf_magic_powers=iconicf['magic_powers'] 
				# pulls out the 'psionic_powers' portion of the named Iconic Framework into a list
				iconicf_psionic_powers=iconicf['psionic_powers'] 
				# pulls out the 'cybernetics' portion of the named Iconic Framework into a list
				iconicf_cybernetics=iconicf['cybernetics'] 
				# pulls out the 'chargen_points' portion of the named Iconic Framework into a list
				iconicf_chargen_points=iconicf['chargen_points'] 
				
				
				#----- This sets the Iconic Framework on the Character -----
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
		  			# set 'swrifts_iconicf' attribute on the character object
					model.update(swrifts_iconicf: self.iconicf_name) 
					# emit to the person running the command that this was set
					client.emit_success t('swrifts.iconicf_set', :name => self.iconicf_name.capitalize)
				end
				
				#----- This sets the Bennies on the Character -----
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
		  			# set 'swrifts_bennies' attribute on the character object
					model.update(swrifts_bennies: self.iconicf_bennies) 
					# emit to the person running the command that this was set
					client.emit_success t('swrifts.iconicf_set', :name => self.iconicf_bennies.capitalize)
				end
				
				#----- This sets the default stats field on the collection -----				
				# If Iconic Framework being set has this field in iconicf.yml, run the command.
				if (iconicf_stats) 
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					iconicf_stats.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						setthing = "#{key}".downcase
						# alias the 'rating' for the same reason
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# create the collection
							SwriftsStats.create(name: setthing, rating: setrating, character: model)
						end
					end
					client.emit_success t('swrifts.iconicstats_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					client.emit_failure ("This Iconic Framework has no Stats")
				end

				#----- This sets the default skills on the Character -----				
				if (iconicf_skills)
					iconicf_skills.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsSkills.create(name: setthing, rating: setrating, character: model)
						end
					end
					client.emit_success t('swrifts.iconicskills_set')
				else 
					client.emit_failure ("This Iconic Framework has no Skills")
				end 

				#----- This sets the default Chargen Points on the Character -----				
				if (iconicf_chargen_points)
					iconicf_chargen_points.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsChargenpoints.create(name: setthing, rating: setrating, character: model)
						end
					end
					client.emit_success t('swrifts.iconicchargenpoints_set')
				else 
					client.emit_failure ("This Iconic Framework has no Chargen Points")
				end				

				#----- This sets the default Hinderances on the Character -----	
				if (iconicf_hinderances) 
					iconicf_hinderances.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsHinderances.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconichinderances_set')
				else 
					client.emit_failure ("This Iconic Framework has no Hinderances")
				end
				#----- This sets the default Edges on the Character -----				
				if (iconicf_edges)
					iconicf_edges.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsEdges.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconicedges_set')
				else 
					client.emit_failure ("This Iconic Framework has no Edges")
				end

				#----- This sets the default Magic Powers on the Character -----	
					if (iconicf_magic_powers)
					iconicf_magic_powers.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsMpowers.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconicmpowers_set')
				else 
					client.emit_failure ("This Iconic Framework has no Magic Powers")
				end 

				# ----- This sets the default Psionic Powers on the Character -----	
				if (iconicf_psionic_powers)
					iconicf_psionic_powers.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsPpowers.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconicppowers_set')
				else 
					client.emit_failure ("This Iconic Framework has no Psionic Powers")
				end

				# ----- This sets the default Cybernetics on the Character -----	
				if (iconicf_cybernetics)
					iconicf_cybernetics.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsCybernetics.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconiccybernetics_set')
				else 
					client.emit_failure ("This Iconic Framework has no Cybernetics")
				end
				
				#----- This sets the default Abilities on the Character -----	
				if (iconicf_abilities)
					iconicf_abilities.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsAbilities.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconicabilities_set')
				else 
					client.emit_failure ("This Iconic Framework has no Abilities")
				end
				
				#----- This sets the default Complications on the Character -----
				if (iconicf_complications)
					iconicf_complications.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwriftsComplications.create(name: setthing, character: model)
						end
					end
					client.emit_success t('swrifts.iconiccomplications_set')
				else 
					client.emit_failure ("This Iconic Framework has no Complications")
				end
				
				client.emit_success t('swrifts.iconicf_complete')
			end
#----- End of def handle -----	

		end
    end
end