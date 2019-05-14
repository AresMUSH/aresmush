$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Portals

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("portals", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "portal"
        return PortalRequestHandler
      when "portalEdit"
        return PortalEditRequestHandler
      end
      nil
    end

  end
end
