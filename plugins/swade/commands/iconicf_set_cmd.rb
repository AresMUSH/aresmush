module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :target, :iconicf_name, :iconicf_attributes, :setattribute, :setvalue
			
		def parse_args
			# if (cmd.args =~ /[^\/]+\=.+\/.+/)
			  # args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
			  # self.name = trim_arg(args.arg1)
			  # self.ability_name = titlecase_arg(args.arg2)
			  # self.rating = trim_arg(args.arg3)
			# else
			# args = cmd.parse_args(ArgParser.arg1)
			
			#self version
			  self.target = enactor_name #Set the character to be the current character
			  self.iconicf_name = trim_arg(cmd.args)
			# end
		end

		def required_args
			[ self.target, self.iconicf_name ]
		end
			
			# def check_valid_iconicf
				# return t('swade.iconicf_invalid_name') if !Swade.is_iconicf_valid_name?(self.iconicf_name)
				# return nil
			# end
		  
			# def check_can_set
				# return nil if enactor_name == self.target
				# return nil if Swade.can_manage_abilities?(enactor)
				# return t('dispatcher.not_allowed')
			# end     
		  
			# def check_chargen_locked
				# return nil if Swade.can_manage_abilities?(enactor)
				# Chargen.check_chargen_locked(enactor)
			# end
      
			#def handle
				#client.emit ("Hello World")
				#ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
				#config = Swade.find_iconicf_config(model.swade_iconicf)
				#Swade.set_iconicf(model, self.iconicf_name)
				#client.emit_success t('swade.iconicf_set')
			#end
			
			def handle  
				#enactor.update(iconicfname: self.iconicfname)
				#client.emit_success "Iconic Framework set!"			
				iconicf = Swade.get_iconicf(self.enactor, self.iconicf_name)
				if (iconicf)
					#set the iconic framework on the character
					setattribute= "swade_iconicf_name"
					ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
						SwadeAttribute.create(name: self.setattribute, value: self.iconicf_name, character: model)
						    model.update(swade_iconicf_name: self.iconicf_name)
							client.emit_success t('swade.iconicf_set', :name => self.iconicf_name)
					end				
					client.emit (iconicf['attributes'].downcase)
					iconicf_name=iconicf['name'].downcase
					iconicf_attributes=iconicf['attributes']
					iconicf_attributes.each { |key, value| client.emit("k: #{key}, v: #{value}") }					
					iconicf_attributes.each do |key, value|
						setattribute = "swade_#{key}".downcase
						client.emit (setattribute)
						setvalue = "#{value}"
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							SwadeAttribute.create(name: self.setattribute, value: self.setvalue, character: model)
						    model.update(swade_setattribute: self.setvalue)
							client.emit_success t('swade.iconicattributes_set', :name => setattribute)
						end
					end
					
					# client.emit (iconicf_name)
					# client.emit (iconicf_attributes)
					# enactor.update(swade_iconicfname: self.iconicf_name)
					# client.emit_success t('swade.iconicf_set', :name => self.iconicf_name)
					# enactor.update(swade_attributes: self.iconicf_attributes)
					# client.emit_success t('swade.iconicattributes_set', :name => self.iconicf_attributes)					
				else
					client.emit ('nothing')
				end

        
				#if (!iconicf)
				#client.emit_failure t('swade.iconicf_invalid_type')
				#return
				#end
        
				#values = iconicf['values']
				#if (self.value && values)
					#self.value = values.keys.find { |v| v.downcase == self.value.downcase }
					#if (!self.value)
						#client.emit_failure t('swade.iconicf_invalid', :iconicf => self.iconicf_name)
						#return
					#end
				#end
        
				#ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
					#Swade.set_iconicf(model, self.iconicf_name, self.value)
                    
					#if (!self.value)
						#client.emit_success t('swade.iconicf_cleared', :iconicf => self.iconicf_name)
					#else
						#client.emit_success t('swade.iconicf_set', :iconicf => self.iconicf_name, :value => self.value)
					#end
				#end
			end
		end
    end
end