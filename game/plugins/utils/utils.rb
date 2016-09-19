$:.unshift File.dirname(__FILE__)
load "lib/autospace_cmd.rb"
load "lib/colors_cmd.rb"
load "lib/echo_cmd.rb"
load "lib/edit_prefix_cmd.rb"
load "lib/last_cmd.rb"
load "lib/math_cmd.rb"
load "lib/noop_cmd.rb"
load "lib/recall_cmd.rb"
load "lib/save_cmd.rb"
load "lib/sweep_cmd.rb"
load "lib/sweep_kick_cmd.rb"
load "lib/utils_model.rb"
load "utils_interfaces.rb"

module AresMUSH
  module Utils
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("utils", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/ansi.md", "help/autospace.md", "help/echo.md", "help/edit.md", "help/last.md", "help/math.md", "help/save.md", "help/substitutions.md", "help/sweep.md" ]
    end
 
    def self.config_files
      [ "config_utils.yml" ]
    end
 
    def self.locale_files
      [ "locale/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end