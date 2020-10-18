module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character

			end

			def required_args
				[ self.target_name]
			end

			

			def handle

			iconicf = Swrifts.get_iconicf(self.target_name, "Test") #get the Iconic Framework entry from the yml
			
			system=iconicf
			model=enactor
			
			if (system['hj1_options']) && !Swrifts.is_valid_cat?(model,"hc1") #See if there are any HJ slots outlined AND they haven't been set already
				counter = 0
				system.each do | title, value |
					title = title.slice(0,2)
					if title == "hj" 
						counter = counter + 1
					else
					end						
				end
				counter = *(1..counter)
				counter.each do |key|
					setthing = "hj#{key}"
					setrating = rand(1..10)
					settable = "None"
					setdesc = "None"
					SwriftsHeroesj.create(name: setthing, table: settable, rating: setrating, description: setdesc, character: model)
				end
			elsif Swrifts.is_valid_cat?(model,"hc1") #See if they already have HJs set up
				client.emit ("Second if")
				counter = 0
				system.each do | title, value |
					title = title.slice(0,2)
					if title == "hj" 
						counter = counter + 1
					else
					end						
				end
				counter = *(1..counter)
				counter.each do |key|
					setthing = "hj#{key}"
					hj_set = model.swrifts_heroesj.select { |a| a.name.downcase == setthing }.first	
					client.emit (hj_set.inspect)
					settable = "None"
					setdesc = "None"
					hj_set.update(table: settable, description: setdesc, character: model)
				end
			else
			end
				
			end
			
		end
	end
end