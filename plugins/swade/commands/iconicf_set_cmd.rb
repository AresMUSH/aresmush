module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target, :iconicf_name
			
			def parse_args
				  self.target = enactor_name #Set the character to be the current character
				  self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
			end

			def required_args
				[ self.target, self.iconicf_name ]
			end
				
				
			def handle  
				client.emit (self.target)
				client.emit (self.iconicf_name)
				client.emit ("-----")
				verified_iconicf = Swade.get_iconicf(self.enactor, self.iconicf_name)
				client.emit (verified_iconicf)
			end
		end
    end
end