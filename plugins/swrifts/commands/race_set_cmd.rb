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
				race_name = self.race_name


				race = Swrifts.find_race_config(self.race_name) #get the race entry we're working with
				carray = race.select{ |a| a == "complications" }.first #pull the complications array out of the race entry
				cvalue = carray[1] #pull the complications value out of the array

				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|	
					edgecheck = model.swrifts_edges
					cjl = ''
					edgecheck.each do |c|
						cjl << "#{c}"
					end
					earray = edgecheck.select{ |a| a.name == "Ab magic*" }.first
					client.emit (edgecheck.inspect)
					client.emit (earray.class)
					client.emit (cjl)
				end
				
				
				ppe_check = cvalue.include?("Restricted Path PPE^") #see if the race has the value
				isp_check = cvalue.include?("Restricted Path ISP^") #see if the race has the value
				nsb_check = cvalue.include?("Non-Standard Build^") #see if the race has the value
				bp_check = cvalue.include?("Bizzare Physiology^") #see if the race has the value
				
				
				
				# if ppe_check == true
					



				# client.emit_success t('swrifts.race_complete')
			end
#----- End of def handle -----	
			
		end
	end
end