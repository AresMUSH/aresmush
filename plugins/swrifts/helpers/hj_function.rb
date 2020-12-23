module AresMUSH
	module Swrifts

		
## ----- Hero's Journey Start
		
		def self.hj_desc(model, element_name, element_table)
			icfhj_roll = model.swrifts_randnum.select { |a| a.name.downcase == element_name }.first #get the hj1 entry
			icfhj_roll = icfhj_roll.rating # get the roll from hj1 
			hj_yml = Global.read_config('swrifts', 'hjtables') #get all the hjtables yml 
			hj_hash = hj_yml.select { |a| a['name'].downcase == element_table.downcase }.first #get the specific hj info
			return ("#{hj_hash}")			
			hj_rolls = hj_hash['rolls']			
			hj_rolls.each do | roll, desc |
				if roll.is_a?(Integer)
					if roll == icfhj_roll.to_i
						return ("#{desc}")
					else
					end
				else
					eval(roll)
					if eval(roll).include?(icfhj_roll.to_i)
						return ("#{desc}")
					else
					end
				end
			end
		end
## ----- Hero's Journey	End	
	end
end