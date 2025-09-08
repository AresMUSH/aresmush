$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Dotcount

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("dotcount", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
        when "dotcount"
          return DotcountCmd
        end
      return nil
    end

  end
end