$:.unshift File.dirname(__FILE__)
load "engine/help_list_cmd.rb"
load "engine/help_view_cmd.rb"
load "engine/templates/help_list_template.rb"
load "lib/help_api.rb"
load "lib/helpers.rb"
load 'web/help.rb'
load 'web/help_topic.rb'

module AresMUSH
  module Help
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("help", "shortcuts")
    end
 
    def self.load_plugin
      Help.reload_help
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_help.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
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