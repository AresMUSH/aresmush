module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			  
			attr_accessor :target_name, :iconicf_title

			def parse_args
				self.target_name = enactor_name
				self.iconicf_title = "iconicf"
			end

			
			## ----- start of def handle
			def handle

				check = Swrifts.trait_raiting(self.target_name, self.iconicf_title)
				client.emit ( "#{check}" )

			end
			## ----- end of def handle
			
		end
	end
end
