module AresMUSH
  module Swade
    def self.plugin_dir
      File.dirname(__FILE__)
    end
    
   def self.shortcuts
      Global.read_config("swade", "shortcuts")
    end
  end
end