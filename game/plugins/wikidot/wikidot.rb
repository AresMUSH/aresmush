$:.unshift File.dirname(__FILE__)

load "lib/character_page_cmd.rb"
load "lib/log_page_cmd.rb"
load "lib/helpers.rb"
load "templates/log_template.rb"
load "templates/char_template.rb"
load "public/wiki_api.rb"

module AresMUSH
  module Wikidot
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("wikidot", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
    
    def self.config_files
      [ "config_wikidot.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root      
      when "wiki"
        case cmd.switch
        when "char"
          return CharacterPageCmd
        when "log"
          return LogPageCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end