module AresMUSH
	module Swrifts

## ----- Start Race Check

		def self.race_check(model, race, race_name, icf_name)
			carray = race.include? 'complications' #Does the race have complications? We'll use this a bit later.

			if icf_name == "none"
				return false
			else
				iconicf = Swrifts.find_iconicf_config(icf_name) #get the Iconic Framework entry we're working with from the
			end

			# We need to check if the ICF can actually have a race at all.  If it can't just don't do the rest of this function.
			norace_icf = iconicf.select{ |nr| nr == 'complications' }.first #pull the complications from the ICF array
			if ( norace_icf )
				nr_value = norace_icf[1]
				nr_valuenew = nr_value.include?("No Race")
				if (nr_valuenew == true)
					return true
				end

				if ( carray ) #Does the Race have complications?
					norace_race = race.select{ |nr| nr == 'complications' }.first #pull the complications from the Race array
					nrace_value = norace_race[1]
					nrace_valuenew = nrace_value.include?("Dragon*") #Does the complications say Dragon?
					if ( nrace_valuenew ) #if it does
						nr_valuenew = nr_value.include?("Dragon*") #Does the ICF say it can be a dragon?
						if ( !nr_valuenew ) #if not, disable entry
							return false
						end
					end
				end
			end

			#dragon_race = race_name.include?("dragon")
			#dragon_icf = icf_name.include?("dragon")

			#if dragon_race && dragon_icf
				#return false
			#elsif dragon_race || dragon_icf
				#return true
			#else
			#end


			if carray == true
				carray = race.select{ |a| a == "complications" }.first #pull the complications array out of the race entry

				cvalue = carray[1] #pull the complications value out of the array
				ppe_check = cvalue.include?("Restricted Path PPE^") #see if the race has the value
				isp_check = cvalue.include?("Restricted Path ISP^") #see if the race has the value
				cyber_check = cvalue.include?("Cyber Resistant^") #see if the race has the value
				nsb_check = cvalue.include?("Non-Standard Build^") #see if the race has the value
				bp_check = cvalue.include?("Bizarre Physiology^") #see if the race has the value

				icf_edges = iconicf['edges']
				icf_cyber = iconicf['cybernetics']
				edgecheck = icf_edges.to_s.downcase

				if ppe_check == true
					abmagic = edgecheck.include? "ab magic*"
					abmiracles = edgecheck.include? "ab miracles*"
					if (abmagic) || (abmiracles)
						return true
					else #continue
					end
				else #continue
				end

				if isp_check == true
					abpsionics = edgecheck.include? "ab psionics*"
					if (abpsionics)
						return true
					else #continue
					end
				else #continue
				end

				if cyber_check == true
					if (icf_cyber)
						return true
					else #continue
					end
				else #continue
				end

				if nsb_check == true
				pajcheck = edgecheck.include? "power armor jock*"
					if (pajcheck)
						return true
					else #continue
					end
				else #continue
				end

				if bp_check == true
					icf_name = icf_name.downcase
					if icf_name.include? "juicer" || "crazy"
						return true
					else #continue
					end
				else #continue
				end
			else
			end
		end

## ----- End Race Check

	end
end
