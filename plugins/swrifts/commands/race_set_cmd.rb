module AresMUSH    
	module Swrifts
		class RaceSetCmd
			include CommandHandler
	  
			attr_accessor :target_name, :race_name, :race_title, :swrifts_race
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.race_name = trim_arg(cmd.args) #Set 'race_name' to be the inputted Race
				self.race_title = "race"
				# self.swrifts_race = "swrifts_race:" 

			end

			def required_args
				[ self.target_name, self.race_name ]
			end
			
  
  			#----- Check to see:
			def check_valid_iconicf
				if !Swrifts.is_valid_tname?(self.race_name, "races") #Is the Race in the list
					return t('swrifts.race_invalid_name', :name => self.race_name.capitalize) 
				# elsif
					# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						# if Swrifts.trait_set?(model,"race") #Is the Race already set
							# return t('swrifts.trait_already_set',:name => "Race")
						# end
					# end
				# elsif
					# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						# if !Swrifts.is_valid_cat?(model,"traits") or !Swrifts.trait_set?(model,"iconicf")
							# return t('swrifts.use_command',:name => "iconicf")
						# end
					# end
				end
			end
  
  
  
 #----- Begin of def handle -----			 
			def handle
				race = Swrifts.find_race_config(self.race_name) #get the race entry we're working with
				icf_hash = enactor.swrifts_traits.select { |a| a.name == "iconicf" }.first
				icf_name = icf_hash.rating
				
				client.emit (icf_name)
				
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					
					if icf_name == "juicer" or "crazy"
						client.emit ("true")
						return
					else
						client.emit ("false")
						return
					end
					
					
					rc = Swrifts.race_check(model, race, self.race_name)
					if rc == true
						client.emit_failure t('swrifts.race_invalid', :race => self.race_name.capitalize, :icf => icf_name.capitalize)
					else
						trait = Swrifts.find_traits(model, "race")				
						trait.update(rating: self.race_name)
						Swrifts.run_system(model, race)
						client.emit_success t('swrifts.race_complete', :race => self.race_name.capitalize)
					end
				end
			end
#----- End of def handle -----	
			
		end
	end
end