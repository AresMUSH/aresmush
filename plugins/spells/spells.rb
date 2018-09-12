$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Spells

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("spells", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)

    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
