module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
			      
			attr_accessor :target, :iconicf_name, :swade_iconicf
			
			def parse_args
				self.target = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.swade_iconicf = "swade_iconicf:"

			end

			def required_args
				[ self.target, self.iconicf_name ]
			end
			
			def check_valid_iconicf
				return t('swade.iconicf_invalid_name', :name => self.iconicf_name.capitalize) if !Swade.is_valid_iconicf_name?(self.iconicf_name)
				return nil
			end
#----- Begin of def handle -----			
			def handle  
				iconicf = Swade.get_iconicf(self.enactor, self.iconicf_name)
				iconicf_stats=iconicf['stats']
				iconicf_skills=iconicf['skills']
				iconicf_hinderances=iconicf['hinderances']
				iconicf_edges=iconicf['edges']
				iconicf_abilities=iconicf['abilities']
				iconicf_complications=iconicf['complications']
				iconicf_magic_powers=iconicf['magic_powers']
				iconicf_psionic_powers=iconicf['psionic_powers']
				iconicf_cybernetics=iconicf['cybernetics']
				iconicf_chargen_points=iconicf['chargen_points']
				
				
				#----- This sets the Iconic Framework on the Character -----
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					attr = self.iconicf_name
				    
					if (attr == nil)
						attr.delete
						client.emit_success t('swade.iconicf_cleared')
						return
					end
		  
					model.update(swade_iconicf: self.iconicf_name)
					client.emit_success t('swade.iconicf_set', :name => self.iconicf_name.capitalize)
				end
				
				#----- This sets the default stats on the Character -----				
				iconicf_stats.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeStats.create(name: setthing, rating: setrating, character: model)
					end
				end
				client.emit_success t('swade.iconicstats_set')

				#----- This sets the default skills on the Character -----				
				iconicf_skills.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeSkills.create(name: setthing, rating: setrating, character: model)
					end
				end
				client.emit_success t('swade.iconicskills_set') 

				#----- This sets the default Chargen Points on the Character -----				
				iconicf_chargen_points.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeChargenpoints.create(name: setthing, rating: setrating, character: model)
					end
				end
				client.emit_success t('swade.iconicchargenpoints_set')				

				#----- This sets the default Hinderances on the Character -----				
				iconicf_hinderances.each do |key|
					setthing = "#{key}".downcase
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeHinderances.create(name: setthing, character: model)
					end
				end
				client.emit_success t('swade.iconichinderances_set')

				#----- This sets the default Edges on the Character -----				
				iconicf_edges.each do |key|
					setthing = "#{key}".downcase
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeEdges.create(name: setthing, character: model)
					end
				end
				client.emit_success t('swade.iconicedges_set')

				#----- This sets the default Magic Powers on the Character -----				
				iconicf_magic_powers.each do |key|
					setthing = "#{key}".downcase
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeMpowers.create(name: setthing, character: model)
					end
				end
				client.emit_success t('swade.iconicmpowers_set') 

				# ----- This sets the default Psionic Powers on the Character -----				
				# iconicf_psionic_powers.each do |key|
					# setthing = "#{key}".downcase
					# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						# SwadePpowers.create(name: setthing, character: model)
					# end
				# end
				# client.emit_success t('swade.iconicppowers_set')

				# ----- This sets the default Cybernetics on the Character -----				
				# iconicf_cybernetics.each do |key|
					# setthing = "#{key}".downcase
					# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						# SwadeCybernetics.create(name: setthing, character: model)
					# end
				# end
				# client.emit_success t('swade.iconiccybernetics_set')
				
				#----- This sets the default Abilities on the Character -----				
				iconicf_abilities.each do |key|
					setthing = "#{key}".downcase
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeAbilities.create(name: setthing, character: model)
					end
				end
				client.emit_success t('swade.iconicabilities_set')
				
				#----- This sets the default Complications on the Character -----				
				iconicf_complications.each do |key|
					setthing = "#{key}".downcase
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeComplications.create(name: setthing, character: model)
					end
				end
				client.emit_success t('swade.iconiccomplications_set')
				
				client.emit_success t('iconicf_complete')
			end
#----- End of def handle -----	
		end
    end
end