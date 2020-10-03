module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			  
			attr_accessor :target_name

			def parse_args
				self.target_name = enactor_name
			end

			
			## ----- start of def handle
			def handle

				check = Swrifts.init_complete(self.target_name)
				client.emit ( "#{check}" )

			end
			## ----- end of def handle
			
		end
	end
end
