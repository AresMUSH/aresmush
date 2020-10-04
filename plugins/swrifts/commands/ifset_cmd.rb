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
				name="Elderly"
				 
				yml_data = Global.read_config('swrifts', 'hinderances')
				hinderance_entry = yml_data.select { |a| a['name'].downcase == name.downcase }.first
				client.emit ( "#{hinderance_entry}" )
			end
			
		end
	end
end