module AresMUSH    
	module Swrifts
		class RaceSetCmd
			include CommandHandler
	  
			attr_accessor :target_name, :race_name, :swrifts_race
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.race_name = trim_arg(cmd.args) #Set 'race_name' to be the inputted Race
				self.swrifts_race = "swrifts_race:" 

			end

			def required_args
				[ self.target_name, self.race_name ]
			end
			
			#----- Check to see if what was entered is a Race in game\config\swrifts_race.yml
			# def check_valid_race
				# return t('swrifts.race_invalid_name', :name => self.race_name.capitalize) if !Swrifts.is_valid_race_name?(self.race_name)
				# return nil
			# end
  
  			#----- Check to see:
			def check_valid_iconicf
				if !Swrifts.is_valid_race_name?(self.race_name) #Is the Race in the list
					return t('swrifts.race_invalid_name', :name => self.race_name.capitalize) 
				else
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						if !Swrifts.is_valid_cat?(model,"traits") #If 'traits' is NOT a valid category
							return t('swrifts.iconicf_invalid_init', :name => "Traits") #Tell them to run /init
						elsif !Swrifts.trait_set?(model,"iconicf") #Is the Iconic Framework is NOT set
							return t('swrifts.iconicf_need',:name => "Iconic Framework") #Tell them to set an Iconic Framework
						end
					end
				end
				return nil
			end
  
  
  
 #----- Begin of def handle -----			 
			def handle
				race = Swrifts.get_race(self.enactor, self.race_name) 

				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					model.update(swrifts_race: self.race_name) 
					# new attrib 'swrifts_race' needs to be in model.rb
					client.emit_success t('swrifts.race_set', :name => self.race_name.capitalize)
				end


			end
#----- End of def handle -----	
			
		end
	end
end