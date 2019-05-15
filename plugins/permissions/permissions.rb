$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Permissions

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("permissions", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("permissions")
      case cmd.switch
      when nil
        return PermissionsListCmd
      end
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
