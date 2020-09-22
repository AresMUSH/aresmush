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
							if (!cmd.args)							 
								return IconicfCmd
							else	
								return IconicfSetCmd
							end
						when "reset"
							return ResetCmd
						when "chargen"
							return ChargenpointsCmd
						# when "race"
							# if (!cmd.args)							 
								# return RaceCmd
							# else
								# return RaceSetCmd
						# when "hj"
							# if (!cmd.args)							 
								# return HjCmd
							# else
								# return HjSetCmd
						# when "fandg"
							# if (!cmd.args)							 
								# return FandgCmd
							# else
								# return FandgSetCmd
						when "stats"
							if (!cmd.args)							 
								return StatsCmd
							else
								return StatsSetCmd
						when "skill"
							if (!cmd.args)							 
								return SkillCmd
							else
								return SkillSetCmd
						when "hind"
							if (!cmd.args)							 
								return HindCmd
							else
								return HindSetCmd
						# when "edge"
							# if (!cmd.args)							 
								# return EdgeCmd
							# else
								# return EdgeSetCmd
						# when "ppower"
							# if (!cmd.args)							 
								# return PpowerCmd
							# else
								# return PpowerSetCmd
						# when "mpower"
							# if (!cmd.args)							 
								# return MpowerSetCmd
							# else
								# return MpowerSetCmd
						# when "cyber"
							# if (!cmd.args)							 
								# return CyberSetCmd
							# else
								#return CyberSetCmd
						else
							client.emit ("Error")
						end
				when "sheet"
					return SheetCmd
				else
				    client.emit ("hello 33333")
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