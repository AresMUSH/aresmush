module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character

			end

			def required_args
				[ self.target_name]
			end

			

			def handle

				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					swrifts.check_features_mod(model, SwriftsHinderances, "Hinderances", "Elderly")
					client.emit ( "test" )
				end
			end
			
		end
	end
end