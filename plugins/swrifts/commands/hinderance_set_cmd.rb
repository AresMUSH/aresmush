module AresMUSH    
	module Swrifts
		class HinderanceSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :hinderance_name
			
			def parse_args
				self.target_name = enactor #Set the character to be the current character
				self.hinderance_name = trim_arg(cmd.args) #Set to the Hinderance passed
			end

			def required_args
				[ self.target_name, self.hinderance_name ]
			end
			
			#----- Check to see:
			def check_valid_iconicf
				check_hind = !Swrifts.is_valid_tname?(self.hinderance_name, "hinderances")
				check_cgen = Swrifts.init_complete(self.target_name)
				client.emit (check_hind)
				client.emit (check_cgen)
				if  check_hind && check_cgen #Is the Hinderance in the list and have they started cgen
					
					return t('swrifts.gen_invalid_name', :name => self.hinderance_name.capitalize, :cat => "Hinderance") 
				else
					client.emit ("Pass")
				end
			end			
			
			
#----- Begin of def handle -----			
			def handle  
					client.emit ("Into the handle")
			

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