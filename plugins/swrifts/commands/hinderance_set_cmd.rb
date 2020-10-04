module AresMUSH    
	module Swrifts
		class HinderanceSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.hinderance_name = trim_arg(cmd.args) #Set to the Hinderance passed
			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end
			
			
#----- Begin of def handle -----			
			def handle  
			

				# ----- This sets the Hinderance on the Character -----	
				setthing = self.hinderance_name.downcase
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					SwriftsHinderances.create(name: setthing, character: model)
				end
				

			end
#----- End of def handle -----	

		end
    end
end