$:.unshift File.dirname(__FILE__)
load "desc_interfaces.rb"
load "lib/desc_edit_cmd.rb"
load "lib/desc_model.rb"
load "lib/describe_cmd.rb"
load "lib/details/detail_delete_cmd.rb"
load "lib/details/detail_edit_cmd.rb"
load "lib/details/detail_set_cmd.rb"
load "lib/helpers.rb"
load "lib/look_cmd.rb"
load "lib/look_detail_cmd.rb"
load "lib/outfits/outfit_delete_cmd.rb"
load "lib/outfits/outfit_edit_cmd.rb"
load "lib/outfits/outfit_list_cmd.rb"
load "lib/outfits/outfit_set_cmd.rb"
load "lib/outfits/outfit_view_cmd.rb"
load "lib/wear_cmd.rb"
load "templates/char_template.rb"
load "templates/exit_template.rb"
load "templates/room_template.rb"

module AresMUSH
  module Describe
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("describe", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/descriptions.md", "help/detail.md", "help/outfit.md" ]
    end
 
    def self.config_files
      [ "config_desc.yml" ]
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