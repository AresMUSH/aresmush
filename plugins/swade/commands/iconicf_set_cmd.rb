module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target_name, :iconicf_name
			
		def parse_args
			# if (cmd.args =~ /[^\/]+\=.+\/.+/)
			  # args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
			  # self.name = trim_arg(args.arg1)
			  # self.ability_name = titlecase_arg(args.arg2)
			  # self.rating = trim_arg(args.arg3)
			# else
			#  args = cmd.parse_args(ArgParser.arg1)
			  self.target_name = enactor_name
			  self.iconicf_name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
			# end
		end

			def required_args
				[self.target_name, self.iconicf_name]
			end
			
			def check_valid_iconicf
				return t('swade.iconicf_invalid_name') if !Swade.is_valid_iconicf_name?(self.iconicf_name)
				return nil
			end
		  
			# def check_can_set
				# return nil if enactor_name == self.target_name
				# return nil if Swade.can_manage_abilities?(enactor)
				# return t('dispatcher.not_allowed')
			# end     
		  
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
			
			# def handle   
				# iconicf = Swade.get_iconicf(self.iconicf_name)
        
				# if (!iconicf)
				# client.emit_failure t('swade.iconicf_invalid_type')
				# return
				# end
        
				# values = iconicf['values']
				# if (self.value && values)
					# self.value = values.keys.find { |v| v.downcase == self.value.downcase }
					# if (!self.value)
						# client.emit_failure t('swade.iconicf_invalid', :iconicf => self.iconicf_name)
						# return
					# end
				# end
        
				# ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
					# Swade.set_iconicf(model, self.iconicf_name, self.value)
                    
					# if (!self.value)
						# client.emit_success t('swade.iconicf_cleared', :iconicf => self.iconicf_name)
					# else
						# client.emit_success t('swade.iconicf_set', :iconicf => self.iconicf_name, :value => self.value)
					# end
				# end
			# end
		end
    end
end