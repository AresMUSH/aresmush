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
						client.emit ("Here1")
						return IconicfCmd
					else
						client.emit ("Here2")
						return IconicfSetCmd
					end
				when "reset"
					return ResetCmd
				when "chargen"
					return ChargenpointsCmd
				when "race"
					if (!cmd.args)							 
						# return RaceCmd
						return PendingCmd
					else
						# return RaceSetCmd
						return PendingCmd
					end
				when "hj"
					if (!cmd.args)							 
						# return HjCmd
						return PendingCmd
					else
						# return HjSetCmd
						return PendingCmd
					end
				when "fandg"
					if (!cmd.args)							 
						# return FandgCmd
						return PendingCmd
					else
						# return FandgSetCmd
						return PendingCmd
					end
				when "stats"
					if (!cmd.args)							 
						return StatsCmd
					else
						# return StatsSetCmd
						return PendingCmd
					end
				when "skill"
					if (!cmd.args)							 
						return SkillCmd
					else
						# return SkillSetCmd
						return PendingCmd
					end
				when "hind"
					if (!cmd.args)							 
						return HindCmd
					else
						# return HindSetCmd
						return PendingCmd
					end
				when "edge"
					if (!cmd.args)							 
						# return EdgeCmd
						return PendingCmd
					else
						# return EdgeSetCmd
						return PendingCmd
					end
				when "ppower"
					if (!cmd.args)							 
						# return PpowerCmd
						return PendingCmd
					else
						# return PpowerSetCmd
						return PendingCmd
					end
				when "mpower"
					if (!cmd.args)							 
						# return MpowerSetCmd
						return PendingCmd
					else
						# return MpowerSetCmd
						return PendingCmd
					end
				when "cyber"
					if (!cmd.args)							 
						# return CyberSetCmd
						return PendingCmd
					else
						#return CyberSetCmd
						return PendingCmd
					end
				else
					client.emit ("Error")
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