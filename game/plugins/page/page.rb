$:.unshift File.dirname(__FILE__)
load "lib/page_cmd.rb"
load "lib/page_dnd.rb"
load "lib/page_model.rb"

module AresMUSH
  module Page
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("page", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/page.md" ]
    end
 
    def self.config_files
      [ "config_page.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
      case cmd.root
      when "page"
        case cmd.switch
        when "dnd"
          return PageDoNotDisturbCmd
        when nil
          # It's a common mistake to type 'p' when you meant '+p' for a channel, but
          # not vice-versa.  So ignore any command that has a prefix. 
          if (!cmd.prefix)
            return PageCmd
          end
        end
      end 
          
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end