module AresMUSH
  module ACL_Where
		def self.plugin_dir
		  File.dirname(__FILE__)
		end
    
	   def self.shortcuts
		  Global.read_config("acl_where", "shortcuts")
		end
	
		def self.get_cmd_handler(client, cmd, enactor)
		  case cmd.root
		  when "where"
			return ACLWhereCmd
		  end
  
		  nil
		end
  end
end