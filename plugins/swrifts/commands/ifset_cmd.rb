module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework

			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end

			

			def self.get_cmd_handler(client, cmd, enactor)
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					Swrifts.check_features_mod(model, SwriftsHinderances, "Hinderances", hinderance_name)
			end

			
		end
	end
end