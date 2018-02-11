$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Tinker
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      if (cmd.root_is?("tinker"))
        return TinkerCmd
      end
      
      nil
    end
  end
end
