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
				hinderance_name="Elderly" 
				yml_data = Global.read_config('swrifts', 'hinderances')
				tn = modifiers

				hinderance_entry = yml_data.select { |a| a['name'].downcase == hinderance_name.downcase }.first
				client.emit ( "#{hinderance_entry}" )
				
				checkmods = hinderance_entry.select { |a| a.name.downcase == tn }.first
				
				if (checkmods)
					client.emit ( "#{checkmods}" )
				else
					client.emit ( "No modifiers" )
				end

				
				# modifiers_entry = hinderance_entry.select { |a| a['name'].downcase == "modifiers" }.first
				# modifiers_value = modifiers_entry.downcase
				# client.emit ( "#{modifiers_value}" )
				# if (modifiers_value)==true
					# return true
				# else
					# return false
				# end
				
			end
			
		end
	end
end