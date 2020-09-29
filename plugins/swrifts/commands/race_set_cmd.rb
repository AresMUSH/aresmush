module AresMUSH    
	module Swrifts
		class RaceSetCmd
			include CommandHandler
	  
			attr_accessor :target, :race_name, :swrifts_race
			
			def parse_args
				self.target = enactor_name #Set the character to be the current character
				self.race_name = trim_arg(cmd.args) #Set 'race_name' to be the inputted Race
				self.swrifts_race = "swrifts_race:" 

			end

			def required_args
				[ self.target, self.race_name ]
			end
			
			#----- Check to see if what was entered is a Race in game\config\swrifts_race.yml
			def check_valid_race
				return t('swrifts.race_invalid_name', :name => self.race_name.capitalize) if !Swrifts.is_valid_race_name?(self.race_name)
				return nil
			end
  
			def handle
				race = Swrifts.get_race(self.enactor, self.race_name) 

				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					model.update(swrifts_race: self.race_name) 
					client.emit_success t('swrifts.race_set', :name => self.race_name.capitalize)
				end


			end
			
			
		end
	end
end