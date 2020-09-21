module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target, :iconicf_name, :swade_iconicf, :setstat, :setrating
			
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
				
				client.emit ("-----")
#----- This sets the default stats on the Character -----				
				
				iconicf = Swade.get_iconicf(self.enactor, self.iconicf_name)
				client.emit (iconicf)
				iconicf_stats=iconicf['stats']
				client.emit (iconicf_stats)
				iconicf_stats.each { |key, rating| client.emit("k: #{key}, r: #{rating}") }					
				iconicf_stats.each do |key, rating|
					setstat = "swade_#{key}".downcase
					setrating = "#{rating}"
					client.emit (setstat)
					client.emit (setrating)
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeStats.create(name: setstat, rating: setrating, character: model)
						client.emit_success t('swade.iconicstats_set', :name => setstat)
					end
				end
			end
		end
    end
end