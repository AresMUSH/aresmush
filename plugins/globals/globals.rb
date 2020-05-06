$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Globals
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("globals", "shortcuts")
    end
  end
end
