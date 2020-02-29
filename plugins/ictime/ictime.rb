$:.unshift File.dirname(__FILE__)


module AresMUSH
  module ICTime
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("ictime", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "ictime"
        return IctimeCmd
      end
      
      nil
    end
    
    def self.check_config
      validator = ICTimeConfigValidator.new
      validator.validate
    end
  end
end
