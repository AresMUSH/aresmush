module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target, :iconicf_name, :swade_iconicf
			
			def parse_args
				self.target = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.swade_iconicf = "swade_iconicf:"
			end

			def required_args
				[ self.target, self.iconicf_name ]
			end
			
			def handle  
				iconicf_exists = Swade.get_iconicf(self.target, self.iconicf_name)
				
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					model.update(swade_iconicf: self.iconicf_name)
					client.emit_success t('swade.iconicf_set', :name => self.iconicf_name.capitalize)
				end
			end
		end
    end
end