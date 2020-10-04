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
				
				collection = Global.read_config('swrifts', 'hinderances')
				client.emit ( "#{collection}" )
				test = collection.select { |a| a['name'].downcase == name.downcase }.first
				client.emit ( "#{test}" )
			end
			
		end
	end
end