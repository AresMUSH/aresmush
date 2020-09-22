$:.unshift File.dirname(__FILE__)

module AresMUSH
	module Swade
		
		def self.plugin_dir
			File.dirname(__FILE__)
		end
    
		def self.shortcuts
			Global.read_config("swade", "shortcuts")
		end

		def self.get_cmd_handler(client, cmd, enactor)
			case cmd.root
				when "swade"
					case cmd.switch
						when "iconicf"
							case cmd.arg
								when ( cmd.arg == nil )
									return IconicfCmd
								else
									return IconicfSetCmd
								end
						when "reset"
							return ResetCmd
						end
				when "sheet"
					return SheetCmd
				end
		end

		def self.get_event_handler(event_name)
		  nil
		end

		def self.get_web_request_handler(request)
		  nil
		end

	end
end