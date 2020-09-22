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
							case cmd.args
								when ( cmd.args == !nil )
									return IconicfSetCmd
								else
									return IconicfCmd
								end
						when "reset"
							return ResetCmd
						# end
						# when "chargen"
							# return ChargenCmd
						# end
						# when "race"
							# return RaceCmd
						# end
						# when "hj"
							# return HjCmd
						# end
						# when "fandg"
							# return FandgCmd
						# end
						when "stat"
							return StatCmd
						end
						# when "skill"
							# return SkillCmd
						# end
						# when "hind"
							# return HindCmd
						# end
						# when "edge"
							# return EdgeCmd
						# end
						# when "ppower"
							# return PpowerCmd
						# end
						# when "mpower"
							# return MpowerCmd
						# end
						# when "cyber"
							# return CyberCmd
						# end
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