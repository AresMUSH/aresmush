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
				iconicf_exists = Swade.get_iconicf(self.enactor, self.iconicf_name)
				client.emit (iconicf_exists)
				if (iconicf_exists)
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						iconicf.create(name: self.iconicf_name, character: model)
						    client.emit_success t('swade.iconicf_set', :name => self.iconicf_name)
			end
		end
    end
end