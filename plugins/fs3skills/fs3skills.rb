$:.unshift File.dirname(__FILE__)

module AresMUSH
  module FS3Skills
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3skills", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
  
    def self.config_files
      [ "config_fs3skills.yml", "config_xp.yml", "config_fs3skills_action.yml",
        "config_fs3skills_attrs.yml", "config_fs3skills_chargen.yml", 
        "config_fs3skills_langs.yml", "config_fs3skills_bg.yml" ]
    end
 

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "abilities"
        return AbilitiesCmd
      when "backup"
        return CharBackupCmd
      when "hook"
        if (cmd.switch_is?("add"))
          return AddHookCmd
        elsif (cmd.switch_is?("remove"))
          return RemoveHookCmd
        end
      when "specialty"
        if (cmd.switch_is?("add"))
          return AddSpecialtyCmd
        elsif (cmd.switch_is?("remove"))
          return RemoveSpecialtyCmd
        end
      when "learn"
        return LearnAbilityCmd
      when "luck"
        case cmd.switch
        when "award"
          return LuckAwardCmd
        when "spend"
          return LuckSpendCmd
        end
      when "raise", "lower"
        return RaiseAbilityCmd
      when "reset"
        return ResetCmd
      when "roll"
        if (cmd.args =~ / vs /)
          return OpposedRollCmd
        else
          return RollCmd
        end
      when "sheet"
        return SheetCmd
      when "ability"
        return SetAbilityCmd
      when "xp"
        case cmd.switch
        when "award"
          return XpAwardCmd    
        when "undo"
          return XpUndoCmd     
        else
          return XpCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return XpCronHandler
      end
      
      nil
    end
  end
end
