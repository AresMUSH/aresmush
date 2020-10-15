module AresMUSH    
	module Swrifts
		class IconicfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name, :iconicf_title, :init
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.iconicf_title = "iconicf"
				self.init = init
			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end
			
			
			#----- Check to see:
			def check_valid_iconicf
				if !Swrifts.is_valid_iconicf_name?(self.iconicf_name) #Is the Iconic Framework in the list
					return t('swrifts.iconicf_invalid_name', :name => self.iconicf_name.capitalize) 
				# else
					# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						# if !Swrifts.is_valid_cat?(model,"traits") #Are there any traits set - i.e INIT completed.
							# return t('swrifts.iconicf_invalid_init', :name => "Traits")
						# elsif Swrifts.trait_set?(model,"iconicf") #Is the iconic framework already set
							# return t('swrifts.trait_already_set',:name => "Iconic Framework")
						# end
					# end
				end
			end
			
#----- Begin of def handle -----			
			def handle  
			
				race_trait = enactor.swrifts_traits.select { |a| a.name == "race" }.first #get the Race trait off of the character	
				
				if (race_trait) == "None"
					client.emit (race_trait.inspect)
					race_trait = nil
					client.emit (race_trait.inspect)
				else
					client.emit (race_trait.inspect)
				end
				
				init = Global.read_config('swrifts', 'init')
				
				iconicf = Swrifts.get_iconicf(self.enactor, self.iconicf_name) #get the Iconic Framework entry from the yml
					
				if (race_trait)
					race_name = race_trait.rating #get the Race name off the character		
					race = Swrifts.find_race_config(self.race_name) #get the Race entry we're working with from the yml
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						
						rc = Swrifts.race_check(model, race, race_name, self.iconicf_name)
						if rc == true
							client.emit_failure t('swrifts.iconicf_invalid', :race => race_name.capitalize, :icf => self.iconicf_name.capitalize)
						else		
							enactor.delete_swrifts_chargen #clear out the character
							
							Swrifts.run_init(model, init)	

							Swrifts.run_system(model, iconicf)
							iconicf_trait = Swrifts.find_traits(model, self.iconicf_title)				
							iconicf_trait.update(rating: self.iconicf_name)

							Swrifts.run_system(model, race)
							race_trait.update(rating: race_name)
						end
					end
				else
					enactor.delete_swrifts_chargen #clear out the character
									
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						Swrifts.run_init(model, init)
						
						iconicf_trait = Swrifts.find_traits(model, self.iconicf_title)				
						iconicf_trait.update(rating: self.iconicf_name)
						Swrifts.run_system(model, iconicf)
					end
				end
				client.emit_success t('swrifts.iconicf_complete')
			end
#----- End of def handle -----	

		end
    end
end