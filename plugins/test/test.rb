$:.unshift File.dirname(__FILE__)

module AresMUSH
	module test
		
		def self.plugin_dir
		  File.dirname(__FILE__)
		end
    
		def self.shortcuts
		  Global.read_config("test", "shortcuts")
		end

		def self.get_cmd_handler(client, cmd, enactor)
		  case cmd.root
		  when "attribute"
			if (cmd.switch_is?("set"))
			  return AttributeSetCmd # test/commands/attribute_set_cmd.rb
			else
			  return AttributesCmd #test/commands/attributes_cmd.rb
			end
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
