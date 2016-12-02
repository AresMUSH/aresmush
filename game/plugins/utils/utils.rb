$:.unshift File.dirname(__FILE__)
load "utils_api.rb"
load "lib/autospace_cmd.rb"
load "lib/colors_cmd.rb"
load "lib/dice_cmd.rb"
load "lib/echo_cmd.rb"
load "lib/edit_prefix_cmd.rb"
load "lib/math_cmd.rb"
load "lib/recall_cmd.rb"
load "lib/shortcuts_cmd.rb"
load "lib/shortcut_add_cmd.rb"
load "lib/shortcut_delete_cmd.rb"
load "lib/save_cmd.rb"
load "lib/set_catcher_cmd.rb"
load "lib/sweep_cmd.rb"
load "lib/sweep_kick_cmd.rb"
load "lib/utils_model.rb"

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
      [ "help/ansi.md", "help/dice.md", "help/echo.md", "help/edit.md", "help/math.md", 
        "help/save.md", "help/formatting.md", "help/sweep.md", "help/shortcuts.md"]
    end
 
    def self.config_files
      [ "config_utils.yml" ]
    end
 
    def self.locale_files
      [ "locale/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "colors"
        return ColorsCmd
      when "dice"
        return DiceCmd
      when "echo"
        return EchoCmd
      when "edit"
        if (cmd.switch_is?("prefix"))
          return EditPasswordCmd
        end
      when "math"
        return MathCmd
      when "recall"
        return RecallCmd
      when "save"
        return SaveCmd
      when "set"
        return SetCatcherCmd
      when "shortcuts"
        return ShortcutsCmd
      when "shortcut"
        case cmd.switch
        when "add"
          return ShortcutAddCmd
        when "delete"
          return ShortcutDeleteCmd
        end
      when "sweep"
        case cmd.switch
        when "kick"
          return SweepKickCmd
        else
          return SweepCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end