module AresMUSH
	module Swrifts
 
## ----- Init
		
		def self.init_complete(char)
			char.swrifts_traits
		end
		
		def self.run_init(model, init)
			
			rand_num_check = model.swrifts_randnum.empty?
			
			if rand_num_check == true
				hj_nums = [1, 2, 3, 4, 5]
				fandg_nums = [1, 2, 3, 4, 5]
				hj_nums.each do |key|
					setthing = "hj#{key}"
					setrating = rand(1..10)
					SwriftsRandnum.create(name: setthing, rating: setrating, character: model)
				end
				fandg_nums.each do |key|
					setthing = "fandg#{key}"
					setrating = rand(1..10)
					SwriftsRandnum.create(name: setthing, rating: setrating, character: model)
				end
			else	
			end			
			
			#----- This sets the default traits field on the collection -----				
			if (init['traits']) 
			traits = init['traits']
				# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
				traits.each do |key, rating|
					# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
					setthing = key.downcase
					# alias the 'rating' for the same reason
					setrating = rating
					SwriftsTraits.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Base Traits Set!")
			else 
				# If the this field isn't in swrifts_init.yml, skip and emit to enactor
				# client.emit_failure ("Init_char Error - Traits")
			end				
			
			#----- This sets the default stats field on the collection -----				
			if (init['stats']) 
			stats = init['stats'] 
				stats.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsStats.create(name: setthing, rating: setrating, character: model)
				end
			else 
				# client.emit_failure ("Init_char Error - Stats")
			end
						
			#----- This sets the maximum stats field on the collection -----				
			if (init['stat_max']) 
			stat_max = init['stat_max']
				stat_max.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsStatsmax.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Stat Maximums Set!")
			else 
				# client.emit_failure ("Init_char Error - Stat_max")
			end
						
			# ----- This sets the default minimums on the Character -----				
			if (init['chargen_min'])
			chargen_min = init['chargen_min']
				chargen_min.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsChargenmin.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Chargen Mins Set!")
			else 
				# client.emit_failure ("Init_char Error - Chargen_Min")
			end  			 						
						
			#----- This sets the default Advances on the Character -----				
			if (init['advances'])
			advances = init['advances']					
				advances.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsAdvances.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Advances Set!")
			else 
				# client.emit_failure ("Init_char Error - Advances")
			end 		
						
			#----- This sets the default derived stats field on the collection -----				
			if (init['dstats']) 
			dstats = init['dstats']
				dstats.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsDstats.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Derived Stats Set!")
			else 
				# client.emit_failure ("Init_char Error - DStats")
			end

			# ----- This sets the default skills on the Character -----				
			if (init['skills'] )
			skills = init['skills'] 
				skills.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsSkills.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Skills Set!")
			else 
				# client.emit_failure ("Init_char Error - Skills")
			end 					
				

			# ----- This sets the default Chargen Points on the Character -----				
			if (init['chargen_points'] )
			chargen_points = init['chargen_points'] 
				chargen_points.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsChargenpoints.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Chargen Points Set!")
			else 
				# client.emit_failure ("Init_char Error - Chargen Points")
			end			

			#----- This sets the default counters field on the collection -----				
			if (init['counters']) 
			counters = init['counters']
				counters.each do |key, rating|
					setthing = "#{key}".downcase
					setrating = "#{rating}"
					SwriftsCounters.create(name: setthing, rating: setrating, character: model)
				end
				# client.emit_success ("Counters Set!")
			else 
				 # client.emit_failure ("Init_char Error - Counters")
			end
			
		end
## ----- End Init
	end
end