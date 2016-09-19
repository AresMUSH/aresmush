$:.unshift File.dirname(__FILE__)
load "chargen_interface.rb"
load "lib/app_approve_cmd.rb"
load "lib/app_cmd.rb"
load "lib/app_model.rb"
load "lib/app_reject_cmd.rb"
load "lib/app_submit_cmd.rb"
load "lib/app_unapprove_cmd.rb"
load "lib/app_unsubmit_cmd.rb"
load "lib/bg_edit_cmd.rb"
load "lib/bg_set_cmd.rb"
load "lib/bg_view_cmd.rb"
load "lib/chargen_next_prev_cmd.rb"
load "lib/chargen_stage_locks.rb"
load "lib/chargen_start_cmd.rb"
load "lib/helpers.rb"
load "templates/bg_template.rb"

module AresMUSH
  module Chargen
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("chargen", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_bg.md", "help/admin_chargen.md", "help/app.md", "help/bg.md", "help/chargen.md" ]
    end
 
    def self.config_files
      [ "config_chargen.yml" ]
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