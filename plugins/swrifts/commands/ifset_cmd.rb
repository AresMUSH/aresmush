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

			iconicf = Swrifts.get_iconicf(self.target_name, "Test") #get the Iconic Framework entry from the yml
			
				if (iconicf['hj1_options']) #See if there are any HJ slots outlined
					client.emit ("There are HJs outlined")
					
					iconicf.each do | title, value |
						title = title.slice(0,2)
						client.emit ("#{title}")
					
					end
				else
					client.emit ("No HJs outlined")
				end
				
			end
			
		end
	end
end