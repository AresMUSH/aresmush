$:.unshift File.dirname(__FILE__)

module AresMUSH
  module AltTracker

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("alttracker", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "register"
        case cmd.switch
        when "alt"
          return RegisterAltCmd
        when "update"
          return RegisterUpdateCmd
        when "word"
          return RegisterWordCmd
        when "wordcheck"
          return RegisterWordcheckCmd
        when "status"
          return RegisterStatusCmd
        when "ban"
          return RegisterBanCmd
        when "unban"
          return RegisterUnbanCmd
        when "banhistory"
          return RegisterBanhistoryCmd
        when nil
          return RegisterCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_web_request_handler(request)
      case request.cmd
      when "altStatus"
        return AltStatusRequestHandler
      when "altRegister"
        return AltRegisterRequestHandler
      when "altRegisterAlt"
        return AltRegisterAltRequestHandler
      when "altUpdate"
        return AltUpdateRequestHandler
      end
      nil
    end

  end
end

# Load helpers (module methods)
require File.join(File.dirname(__FILE__), 'helpers.rb')

# Web request handlers (portal API)
Dir[File.join(File.dirname(__FILE__), 'web', '*.rb')].sort.each { |f| require f }

# Command handlers
Dir[File.join(File.dirname(__FILE__), 'commands', '**', '*_cmd.rb')].sort.each { |f| require f }

# Template renderers
Dir[File.join(File.dirname(__FILE__), 'templates', '*_template.rb')].sort.each { |f| require f }
