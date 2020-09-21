module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target, :iconicf_name, :swade_iconicf
			
			def parse_args
				self.target = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.swade_iconicf = "swade_iconicf"
			end

			# def required_args
				# [ self.target, self.iconicf_name ]
			# end
				
				
			def handle  
				client.emit (self.target)
				client.emit (self.iconicf_name)
				client.emit ("----- check to see if the Iconic Framework Exists")
				iconicf_exists = Swade.get_iconicf(self.target, self.iconicf_name)
				client.emit (iconicf_exists)
				client.emit ("----- ")
				if (self.iconicf_name.blank?)
					target.update(swade_iconicf: nil)
					client.emit_success t('swade.iconicf_cleared')
				else
					target.update(self.swade_iconicf self.iconicf_name)
					client.emit_success t('swade.iconicf_set', :name => self.iconicf_name.capitalize)
				end
				# else
					# client.emit_failure t('swade.iconicf_invalid_name', :name=> self.iconicf_name.capitalize)
				# end
			end
		end
    end
end