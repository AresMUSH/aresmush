module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :goals

			def parse_args
				self.goals = trim_arg(cmd.args)
			end

			def handle
				client.emit (enactor)
				client.emit (self.goals)
				client.emit (goals)
				client.emit_success "Goals set!"
			end
		end
	end
end