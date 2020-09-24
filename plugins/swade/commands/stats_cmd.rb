module AresMUSH    
	module Swrifts
		class StatsCmd
			include CommandHandler
		  
			def handle
				types = Global.read_config("swrifts", "stats")
				list = types.sort_by { |a| a['name']}
				template = StatsTemplate.new list
				client.emit template.render
			end
		end
	end
end