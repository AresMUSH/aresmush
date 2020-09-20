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
      when "iconicf"
	    case cmd.switch
        #if (cmd.switch_is?("set"))
		when "set"
          return IconicfSetCmd
        else
          return IconicfCmd
        end
      when "sheet"
        return SheetCmd
      end
      return nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end