module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			  
			attr_accessor :target_name, :iconicf_name, :iconicf_title

			def parse_args
				self.target = enactor_name
				self.iconicf_name = trim_arg(cmd.args)
				self.iconicf_title = "iconicf"
			end
			
			def required_args
				[ self.target, self.iconicf_name ]
			end

			
			## ----- start of def handle
			def handle
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					trait = Swrifts.find_traits(model, self.iconicf_title)				
					trait.update(rating: self.iconicf_name)
				end
				
				client.emit_success ("Iconic Framework Added")
			end
			## ----- end of def handle
			
		end
	end
end
