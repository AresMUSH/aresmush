module AresMUSH    
	module Swrifts
		class InitCharCmd
			include CommandHandler
			      
			attr_accessor :target, :init
			
			def parse_args
				self.target = enactor_name #Set the character to be the current character
				self.init = init
			end

			def required_args
				[ self.target ]
			end
			
			# def check_if_started
				# return t('swrifts.init_started') if !Swrifts.is_valid_chargen?(self.target)
				# return nil
			# end

#----- Begin of def handle -----			
			def handle  
				# Swrifts.get_init_char - 'Swrifts' is the plugin folder. 'get' is the command. 'init' is the .yml file in the 'config' folder. 

				#----- Check to see if CGen has already been started. If it has, exit with a message. -----
				
				ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|  #get the character model to work with
				chartraits = model.swrifts_traits #Return the traits collection.
				if (chartraits.size > 0) #If the traits collection has *anything* in it, don't do the init
					client.emit ("You've already initialised your sheet. Please proceed with Chargen") #This needs to be tidied up
					return
				else  #If the traits collection has nothing in it, init away
				# init = Swrifts.get_init(self.enactor, self.init) 
					init = Global.read_config('swrifts', 'init')				
					traits = init['traits']
					counters = init['counters']
					stats = init['stats'] 
					stat_max = init['stat_max']
					dstats = init['dstats']
					chargen_points = init['chargen_points'] 
					skills = init['skills'] 
					chargen_min = init['chargen_min']
					advances = init['advances']					
				end
			end
				
				#----- This sets the default traits field on the collection -----				
				if (traits) 
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					traits.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						setthing = key.downcase
						# alias the 'rating' for the same reason
						setrating = rating
						ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# create the collection
							SwriftsTraits.create(name: setthing, rating: setrating, character: model)
						end
					end
					client.emit_success ("Base Traits Set!")
				else 
					# If the this field insn't in swrifts_init.yml, skip and emit to enactor
					client.emit_failure ("Init_char Error - Traits")
				end

				#----- This sets the default counters field on the collection -----				
				# if (counters) 
					# counters.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsCounters.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Counters Set!")
				# else 
					# client.emit_failure ("Init_char Error - Counters")
				# end
				
				#----- This sets the default stats field on the collection -----				
				# if (stats) 
					# stats.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsStats.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Stats Set!")
				# else 
					# client.emit_failure ("Init_char Error - Stats")
				# end
				
				#----- This sets the maximum stats field on the collection -----				
				# if (stat_max) 
					# stat_max.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsStatMax.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Stat Maximums Set!")
				# else 
					# client.emit_failure ("Init_char Error - Stat_max")
				# end
				
				#----- This sets the default derived stats field on the collection -----				
				# if (dstats) 
					# dstats.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsDstats.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Derived Stats Set!")
				# else 
					# client.emit_failure ("Init_char Error - DStats")
				# end

				#----- This sets the default Chargen Points on the Character -----				
				# if (chargen_points)
					# chargen_points.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsChargenpoints.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Chargen Points Set!")
				# else 
					# client.emit_failure ("Init_char Error - Chargen Points")
				# end			

				#----- This sets the default skills on the Character -----				
				# if (skills)
					# skills.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsSkills.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Skills Set!")
				# else 
					# client.emit_failure ("Init_char Error - Skills")
				# end 					
				
				#----- This sets the default minimums on the Character -----				
				# if (chargen_min)
					# chargen_min.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsChargenMin.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Skills Set!")
				# else 
					# client.emit_failure ("Init_char Error - Skills")
				# end  					
				
				#----- This sets the default Advances on the Character -----				
				# if (advances)
					# advances.each do |key, rating|
						# setthing = "#{key}".downcase
						# setrating = "#{rating}"
						# ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
							# SwriftsAdvances.create(name: setthing, rating: setrating, character: model)
						# end
					# end
					# client.emit_success ("Skills Set!")
				# else 
					# client.emit_failure ("Init_char Error - Skills")
				# end 

				
				client.emit_success ("Character Initilization Complete")
			end
#----- End of def handle -----	

		end
    end
end