$:.unshift File.dirname(__FILE__)
load "lib/channel_alias_cmd.rb"
load "lib/channel_gag_cmd.rb"
load "lib/channel_join_cmd.rb"
load "lib/channel_leave_cmd.rb"
load "lib/channel_list_cmd.rb"
load "lib/channel_model.rb"
load "lib/channel_talk_cmd.rb"
load "lib/channel_title_cmd.rb"
load "lib/channel_who_cmd.rb"
load "lib/event_handling.rb"
load "lib/helpers.rb"
load "lib/management/channel_attribute_cmd.rb"
load "lib/management/channel_create_cmd.rb"
load "lib/management/channel_delete_cmd.rb"
load "templates/channel_list_template.rb"

module AresMUSH
  module Channels
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("channels", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_channels.md", "help/channels.md" ]
    end
 
    def self.config_files
      [ "config_channels.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end