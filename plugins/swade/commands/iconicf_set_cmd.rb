module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :iconicf_name, :swade_iconicf

			def parse_args
				self.iconicf_name = trim_arg(cmd.args)
				self.swade_iconicf = "swade_iconicf"
			end

			def handle
				client.emit (enactor)
				client.emit (self.iconicf_name)
				client.emit (self.swade_iconicf)
			end
		end
	end
end