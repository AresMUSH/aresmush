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
				client.emit (self.race_name)

				race = Swrifts.find_race_config(self.race_name) #get the race entry we're working with
				client.emit (race)
				
				swriftstraits = @char.swrifts_traits
				swriftstraits.to_a.sort_by { |a| a.name }
					.each_with_index
						.map do |a, i| 
						if a.name.downcase == "iconicf"
							return ("#{a.rating}")
						end
					end	


				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					carray = race.include? 'complications'
					if carray == true
						client.emit ("complications apply")
						carray = race.select{ |a| a == "complications" }.first #pull the complications array out of the race entry
						client.emit (carray)
						
						cvalue = carray[1] #pull the complications value out of the array
						client.emit (cvalue)
						
						ppe_check = cvalue.include?("Restricted Path PPE^") #see if the race has the value
						isp_check = cvalue.include?("Restricted Path ISP^") #see if the race has the value
						cyber_check = cvalue.include?("Cyber Resistant^") #see if the race has the value
						nsb_check = cvalue.include?("Non-Standard Build^") #see if the race has the value
						bp_check = cvalue.include?("Bizarre Physiology^") #see if the race has the value

						if ppe_check == true
							edgecheck = model.swrifts_edges
							abmagic = edgecheck.select{ |a| a.name == "ab magic*" }.first
							abmiracles = edgecheck.select{ |a| a.name == "ab magic*" }.first
							if (abmagic) || (abmiracles)
								client.emit t('swrifts.race_invalid', :race => self.race_name.capitalize), :icf => icf.capitalize)
								return
							else #continue
								client.emit ("no ab magic or miracles")
							end
						else #continue
							client.emit ("no magic or miracles complication")
						end
						
						if isp_check == true
							edgecheck = model.swrifts_edges
							abpsionics = edgecheck.select{ |a| a.name == "ab psionics*" }.first
							if (abpsionics)
								client.emit ("You cannot select this race for your current Iconic Framework isp")
								return
							else #continue
								client.emit ("no ab psionics")
							end
						else #continue
							client.emit ("no isp complication")
						end
						
						if cyber_check == true
							charcat = model.swrifts_cybernetics
							if charcat.size > 0
								client.emit ("You cannot select this race for your current Iconic Framework cyber")
								return
							else #continue
								client.emit ("no cybernetics")
							end
						else #continue
							client.emit ("no cyber complication")
						end
						
						if nsb_check == true
							nsbcheck = model.swrifts_edges
							pajock = nsbcheck.select{ |a| a.name == "power armor jock*" }.first
							if (pajock)
								client.emit (pajock)
								client.emit ("You cannot select this race for your current Iconic Framework nsb")
								return
							else #continue
								client.emit ("no power armor jock IF")
							end
						else #continue
							client.emit ("no nsb complication")
						end
						
						if bp_check == true
							icfcheck = model.swrifts_traits
							juicer = icfcheck.select{ |a| a.name == "juicer" }.first
							crazy = icfcheck.select{ |a| a.name == "crazy" }.first
							if (juicer) || (crazy)
								client.emit (juicer)
								client.emit (crazy)
								client.emit ("You cannot select this race for your current Iconic Framework bp")
								return
							else #continue
								client.emit ("not a crazy or juicer")
							end
						else #continue
							client.emit ("no bp complication")
						end
					else
						client.emit ("no complications in race")
					end
					trait = Swrifts.find_traits(model, "race")				
					trait.update(rating: self.race_name)
				end
				client.emit_success t('swrifts.race_complete')
			end
#----- End of def handle -----	
			
		end
	end
end