$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Comps

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("comps", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "comp"
        return CompGiveCmd
      when "comps"
        return CompsCmd
      end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
