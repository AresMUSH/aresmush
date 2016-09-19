$:.unshift File.dirname(__FILE__)
load "bbs_interface.rb"
load "lib/bbs_archive.rb"
load "lib/bbs_board_cmd.rb"
load "lib/bbs_catchup.rb"
load "lib/bbs_delete_cmd.rb"
load "lib/bbs_edit_cmd.rb"
load "lib/bbs_list_cmd.rb"
load "lib/bbs_model.rb"
load "lib/bbs_move_cmd.rb"
load "lib/bbs_new_cmd.rb"
load "lib/bbs_post_cmd.rb"
load "lib/bbs_read_cmd.rb"
load "lib/bbs_reply_cmd.rb"
load "lib/helpers.rb"
load "lib/management/bbs_attribute_cmd.rb"
load "lib/management/bbs_create_board_cmd.rb"
load "lib/management/bbs_delete_board_cmd.rb"
load "lib/management/bbs_delete_confirm_cmd.rb"
load "templates/board_list_template.rb"
load "templates/board_template.rb"
load "templates/post_template.rb"

module AresMUSH
  module Bbs
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("bbs", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_bbs.md", "help/bbs.md" ]
    end
 
    def self.config_files
      [ "config_bbs.yml" ]
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