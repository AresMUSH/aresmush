module AresMUSH
  module ACL_CharModel
		def self.plugin_dir
		  File.dirname(__FILE__)
		end
    
	   def self.shortcuts
		  Global.read_config("acl_char_model", "shortcuts")
		end
	
		def self.get_cmd_handler(client, cmd, enactor)
		  case cmd.root
		  when "aclcm"
			return ACLCharModelCmd
		  end
  
		  nil
		end
  end
end