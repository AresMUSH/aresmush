module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :goals, :swade_iconicf

			def parse_args
				self.goals = trim_arg(cmd.args)
				self.swade_iconicf = "swade_iconicf"
			end

			def handle
				client.emit (enactor)
				client.emit (self.goals)
				client.emit (self.swade_iconicf)
			end
		end
	end
end