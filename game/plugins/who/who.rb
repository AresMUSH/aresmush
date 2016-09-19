$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/hide_cmd.rb"
load "lib/where_cmd.rb"
load "lib/who_cmd.rb"
load "lib/who_events.rb"
load "lib/who_model.rb"
load "templates/char_who_fields.rb"
load "templates/common_who_fields.rb"
load "templates/where_template.rb"
load "templates/who_template.rb"

module AresMUSH
  module Who
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
 
    def self.help_files
      [ "help/who.md" ]
    end
 
    def self.config_files
      [  ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end