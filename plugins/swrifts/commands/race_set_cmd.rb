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
				
				ppe_check = cvalue.include?("Restricted Path PPE^") #see if the race has the value
				isp_check = cvalue.include?("Restricted Path ISP^") #see if the race has the value
				cyber_check = cvalue.include?("Cyber Resistant^") #see if the race has the value
				nsb_check = cvalue.include?("Non-Standard Build^") #see if the race has the value
				bp_check = cvalue.include?("Bizarre Physiology^") #see if the race has the value

				if ppe_check == true
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						edgecheck = model.swrifts_edges
						abmagic = edgecheck.select{ |a| a.name == "ab magic*" }.first
						abmiracles = edgecheck.select{ |a| a.name == "ab magic*" }.first
						if (abmagic) || (abmiracles)
							client.emit ("You cannot select this race for your current Iconic Framework")
							return
						else #continue
						end
					end
				else #continue
				end
				
				if isp_check == true
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						edgecheck = model.swrifts_edges
						abpsionics = edgecheck.select{ |a| a.name == "ab psionics*" }.first
						if (abpsionics)
							client.emit ("You cannot select this race for your current Iconic Framework")
							return
						else #continue
						end
					end
				else #continue
				end
				
				if cyber_check == true
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						cybercheck = Swrifts.is_vald_cat?(model, "cybernetics")
						client.emit (cybercheck)
					end
				else #continue
				end
				
				if nsb_check == true
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						nsbcheck = model.swrifts_edges
						pajock = edgecheck.select{ |a| a.name == "power armor jock*" }.first
						if (pajock)
							client.emit (pajock)
							client.emit ("You cannot select this race for your current Iconic Framework")
							return
						else #continue
							client.emit ("no power armor jock IF")
						end
					end
				else #continue
				end
				
				if bp_check == true
					ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						icfcheck = model.swrifts_traits
						juicer = icfcheck.select{ |a| a.name == "juicer" }.first
						crazy = icfcheck.select{ |a| a.name == "crazy" }.first
						if (juicer) || (crazy)
							client.emit (juicer)
							client.emit (crazy)
							client.emit ("You cannot select this race for your current Iconic Framework")
							return
						else #continue
							client.emit ("not a crazy or juicer")
						end
					end
				else #continue
				end

				
				
				

					



				# client.emit_success t('swrifts.race_complete')
			end
#----- End of def handle -----	
			
		end
	end
end