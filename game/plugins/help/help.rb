$:.unshift File.dirname(__FILE__)
load "help_api.rb"
load "lib/help_list_cmd.rb"
load "lib/help_view_cmd.rb"
load "lib/helpers.rb"
load "templates/help_list_template.rb"

module AresMUSH
  module Help
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("help", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/help.md" ]
    end
 
    def self.config_files
      [ "config_help.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
       return nil if !cmd.root.end_with?("help")
       
       if (cmd.args)
         return HelpViewCmd
       else
         return HelpListCmd
       end
       
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end