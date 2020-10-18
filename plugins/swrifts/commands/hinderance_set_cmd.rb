module AresMUSH    
	module Swrifts
		class HinderanceSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :hinderance_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.hinderance_name = trim_arg(cmd.args) #Set to the Hinderance passed
			end

			def required_args
				[ self.target_name, self.hinderance_name ]
			end
			
			#----- Check to see:
			def check_valid_iconicf
				if !Swrifts.is_valid_tname?(self.hinderance_name, "hinderances") #Is the Hinderance in the list
					return t('swrifts.gen_invalid_name', :name => self.hinderance_name.capitalize, :cat => "Hinderance") 
				else
					client.emit ("No.")
				end
			end			
			
			
#----- Begin of def handle -----			
			def handle  
			
				client.emit ("Start")

				# ----- This sets the Hinderance on the Character -----	
				# setthing = self.hinderance_name.downcase
				# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					# SwriftsHinderances.create(name: setthing, character: model)
				# end
				

			end
#----- End of def handle -----	

		end
    end
end