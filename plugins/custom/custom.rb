$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)      
    when "fatigue"
      case cmd.switch
      when "lower"
        return FatigueLowerCmd    
      when "add"
        return FatigueAddCmd     
      else
        return FatigueCmd
      end
    end
  end
end
