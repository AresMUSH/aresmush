$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Ranks
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("ranks", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "ranks"
        return RanksCmd
        
      when "rank"
        case cmd.switch
        when "set"
          return RankSetCmd
        end
      end
      
      nil
    end
    
    def self.check_config
      validator = RanksConfigValidator.new
      validator.validate
    end
  end
end
