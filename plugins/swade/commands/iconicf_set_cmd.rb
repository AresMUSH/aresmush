module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target_name, :iconicf_name

			def required_args
				[self.target_name, self.iconicf_name]
			end
      
			def check_valid_iconicf
				return t('swade.invalid_iconicf_name') if !Swade.is_valid_iconicf_name?(self.iconicf_name)
				return nil
			end
		  
			def check_can_set
				return nil if enactor_name == self.target_name
				return nil if Swade.can_manage_abilities?(enactor)
				return t('dispatcher.not_allowed')
			end     
		  
			# def check_chargen_locked
				# return nil if Swade.can_manage_abilities?(enactor)
				# Chargen.check_chargen_locked(enactor)
			# end
      
			# def handle
				# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
				# config = Swade.find_iconicf_config(model.swade_iconicf)
				# Swade.set_iconicf(model, self.iconicf_name)
				# client.emit_success t('swade.iconicf_set')
			# end
			
			def handle   
				iconicf = Swade.get_iconicf(self.iconicf_name)
        
				if (!iconicf)
				client.emit_failure t('swade.iconicf_invalid_type')
				return
				end
        
				values = iconicf['values']
				if (self.value && values)
					self.value = values.keys.find { |v| v.downcase == self.value.downcase }
					if (!self.value)
						client.emit_failure t('swade.iconicf_invalid', :iconicf => self.iconicf_name)
						return
					end
				end
        
				ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
					Swade.set_iconicf(model, self.iconicf_name, self.value)
                    
					if (!self.value)
						client.emit_success t('swade.iconicf_cleared', :iconicf => self.iconicf_name)
					else
						client.emit_success t('swade.iconicf_set', :iconicf => self.iconicf_name, :value => self.value)
					end
				end
			end
			
			
		end
    end
  end
end