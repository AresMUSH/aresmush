module AresMUSH    
	module Swrifts
		class HinderanceSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :hinderance_name
			
			def parse_args
				self.target_name = enactor #Set the character to be the current character
				self.hinderance_name = trim_arg(cmd.args) #Set to the Hinderance passed
			end

			def required_args
				[ self.target_name, self.hinderance_name ]
			end
			
			#----- Check to see:
			def check_valid_iconicf
				check_hind = Swrifts.is_valid_tname?(self.hinderance_name, "hinderances")
				check_cgen = self.target_name.swrifts_traits.empty?
				if  check_hind == false
					return t('swrifts.gen_invalid_name', :name => self.hinderance_name.capitalize, :cat => "Hinderance") 
				elsif check_cgen == true
					return t('swrifts.gen_invalid_cgen')
				else
				end
			end			
			
			
#----- Begin of def handle -----			
			def handle  
			
				# charhash = enactor.swrifts_chargenpoints
				
				system_name = self.hinderance_name.downcase
				current_points = Swrifts.point_rating(enactor, 'hind_points')
				group = Global.read_config('swrifts', 'hinderances')
				set = group.select { |a| a['name'].downcase == system_name }.first
				
				client.emit (set.inspect)
				return
				
				set.each do |key, rating| 
					if key == "hind_points"
						mod = "#{rating}".to_i
					else
					end
				end 
				# client.emit (mod)
				
				new_points = current_points + mod
				# client.emit (new_points) 
				
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					points = Swrifts.find_points(model, 'hind_points')	
					# client.emit (points)
					points.update(rating: new_points)
				end				
			
				setthing = self.hinderance_name.downcase
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					SwriftsHinderances.create(name: setthing, character: model)
				end
			end
#----- End of def handle -----	

		end
    end
end