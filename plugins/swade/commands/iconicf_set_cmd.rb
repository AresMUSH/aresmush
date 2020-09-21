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
			
			def check_valid_iconicf
				return t('swade.iconicf_invalid_name', :name => self.iconicf_name.capitalize) if !Swade.is_valid_iconicf_name?(self.iconicf_name)
				return nil
			end
			
			def handle  
			
#----- This sets the Iconic Framework on the Character -----
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					attr = self.iconicf_name
				    
					if (attr == nil)
						attr.delete
						client.emit_success t('swade.iconicf_cleared')
						return
					end
		  
					model.update(swade_iconicf: self.iconicf_name)
					client.emit_success t('swade.iconicf_set', :name => self.iconicf_name.capitalize)
				end
				
#----- This sets the default stats on the Character -----				
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
					attr = Swade.find_stat(model, self.stat_name)
					client.emit (attr)
					# if (attr)
						# attr.update(rating: self.rating)
					# else
						# SwadeStats.create(name: self.stat_name, rating: self.rating, character: model)
					# end
         
					# client.emit_success t('Swade.stat_set')
				end
				
			end
		end
    end
end