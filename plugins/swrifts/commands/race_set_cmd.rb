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
						if Swrifts.trait_set?(model,"iconicf") #Is the Iconic Framework is set
							return t('swrifts.trait_already_set',:name => "iconicf")
						end
					end
				end
				return nil
			end
  
  
  
 #----- Begin of def handle -----			 
			def handle
				race = Swrifts.get_race(self.enactor, self.race_name) 

				## ----- Update Race Framework
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					trait = Swrifts.find_traits(model, self.race_title)				
					trait.update(rating: self.race_name)
				end



				client.emit_success t('swrifts.race_complete')
			end
#----- End of def handle -----	
			
		end
	end
end