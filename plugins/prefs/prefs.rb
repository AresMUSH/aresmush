$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Prefs

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("prefs", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "pref"
        case cmd.switch
        when "filter"
          return FilterPrefsCmd
        when "set"
          return SetPrefsCmd
        when "note"
          return PrefsNoteCmd
        when nil
          return PrefsCmd
        end
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
