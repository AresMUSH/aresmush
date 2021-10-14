$:.unshift File.dirname(__FILE__)
module AresMUSH
  module Openweather

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.init_plugin
      Openweather.current_weather = {}
    end

    def self.shortcuts
      Global.read_config("openweather", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("openweather")
      case cmd.switch
      when "reset"
        return OpenweatherResetCmd
      when nil  
        return OpenweatherCmd
      end
      nil
    end

    def self.get_event_handler(event_name)
      nil
    end

    def self.get_event_handler(event_name)
      case event_name
        when "CronEvent"
          return OpenweatherCronEventHandler
        when "GameStartedEvent"
          return OpenweatherGameStartedEventHandler
      end
    end

    def self.get_web_request_handler(request)
      nil
    end

  end
end
