module AresMUSH    
	module Swrifts
		class RaceSetCmd
			include CommandHandler
	  
			attr_accessor :target_name, :race_name, :race_title, :swrifts_race
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.race_name = trim_arg(cmd.args).downcase #Set 'race_name' to be the inputted Race
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
								
				icf_trait = enactor.swrifts_traits.select { |a| a.name == "iconicf" }.first #get the Iconic Framework trait off of the character
								
				init = Global.read_config('swrifts', 'init')
				
				race = Swrifts.find_race_config(self.race_name) #get the Race entry we're working with from the yml
					
				if (icf_trait)	
					
					icf_name = icf_trait.rating #get the Iconic Framework name off the character
					icf_name = icf_name.downcase
					
					iconicf = Swrifts.get_iconicf(self.enactor, icf_name) #get the Iconic Framework entry from the yml
					
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					
						rc = Swrifts.race_check(model, race, self.race_name, icf_name)
						# client.emit (rc.inspect)

						if rc == true
							client.emit_failure t('swrifts.race_invalid', :race => self.race_name.capitalize, :icf => icf_name.capitalize)
						else		
							enactor.delete_swrifts_chargen #clear out the character
							
							Swrifts.run_init(model, init)	
							
							Swrifts.run_system(model, iconicf)
							icf_trait.update(rating: icf_name)
							
							Swrifts.run_system(model, race)	
							race_trait = Swrifts.find_traits(model, "race") #get the Race trait off of the character
							race_trait.update(rating: self.race_name)
							
							client.emit_success t('swrifts.race_complete', :race => self.race_name.capitalize)
						end
					end
				else
					enactor.delete_swrifts_chargen #clear out the character
					
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						Swrifts.run_init(model, init)
					
						Swrifts.run_system(model, race)	
						
						race_trait = Swrifts.find_traits(model, "race")	 #get the Race trait off of the character
						race_trait.update(rating: self.race_name)

						client.emit_success t('swrifts.race_complete', :race => self.race_name.capitalize)
					end
				end
			end
#----- End of def handle -----	
			
		end
	end
end