$:.unshift File.dirname(__FILE__)

module AresMUSH
	module Swade
		
    def self.plugin_dir
      File.dirname(__FILE__)
    end
    
	def self.shortcuts
      Global.read_config("Swade", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
	  when "attribute"
        if (cmd.switch_is?("set"))
          return AttributeSetCmd # Swade/commands/attribute_set_cmd.rb
        else
          return AttributesCmd #Swade/commands/attributes_cmd.rb
        end
      when "sheet"
        return SheetCmd #Swade/commands/sheet_cmd.rb
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
