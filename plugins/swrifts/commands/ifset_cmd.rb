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
					# Swrifts.check_features_mod(model, SwriftsHinderances, "Hinderances", "Elderly")
					check = model.swrifts_hinderances.select { |a| a.name.downcase == "elderly" }.first
					client.emit ( "#{check}" )
				end
			end
			
		end
	end
end