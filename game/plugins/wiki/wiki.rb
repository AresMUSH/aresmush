$:.unshift File.dirname(__FILE__)

load "lib/wiki_page_cmd.rb"
load "public/wiki_page.rb"
load "public/wiki_page_version.rb"

module AresMUSH
  module Wiki
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
    
    def self.config_files
      []
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root      
      when "wiki"
        case cmd.switch
        when nil
          return WikiPageCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end