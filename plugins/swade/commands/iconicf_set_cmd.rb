module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :iconicf_name

			def parse_args
				self.iconicf_name = trim_arg(cmd.args)
			end

			def handle
				enactor.update(swade_iconicf: self.iconicf_name)
				client.emit_success "Iconic Framework set!"
			end
		end
	end
end