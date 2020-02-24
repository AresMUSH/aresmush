$:.unshift File.dirname(__FILE__)

require 'dentaku'

module AresMUSH
  module Utils
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("utils", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "ascii"
        return AsciiCmd
      when "beep"
        return BeepCmd
      when "color"
        if (cmd.args)
          return ColorModeCmd
        else
          return ColorsCmd
        end
      when "dice"
        return DiceCmd
      when "echo"
        return EchoCmd
      when "edit"
        if (cmd.switch_is?("prefix"))
          return EditPasswordCmd
        end
      when "fansi"
        return ColorModeCmd
      when "math"
        return MathCmd
      when "notes", "note"
        case cmd.switch
        when nil
          return NotesCmd
        when "set"
          return NotesSetCmd
        when "edit"
          return NotesEditCmd
        end
      when "recall"
        return RecallCmd
      when "save"
        return SaveCmd
      when "screenreader"
        return ScreenReaderCmd
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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "rollDice"
        return RollDiceRequestHandler
      when "getNotes"
        return GetNotesRequestHandler
      when "saveNotes"
        return SaveNotesRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = GameConfigValidator.new
      validator.validate
    end
  end
end
