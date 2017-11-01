$:.unshift File.dirname(__FILE__)
load "engine/abilities_cmd.rb"
load "engine/add_hook_cmd.rb"
load "engine/add_spec_cmd.rb"
load "engine/learn_ability_cmd.rb"
load "engine/raise_ability_cmd.rb"
load "engine/remove_hook_cmd.rb"
load "engine/remove_spec_cmd.rb"
load "engine/reset_cmd.rb"
load "engine/roll_cmd.rb"
load "engine/roll_opposed_cmd.rb"
load "engine/set_ability_cmd.rb"
load "engine/xp_award_cmd.rb"
load "engine/xp_undo_cmd.rb"
load "engine/xp_cmd.rb"
load "engine/luck_award_cmd.rb"
load "engine/luck_spend_cmd.rb"
load "engine/char_backup_command.rb"
load "engine/sheet_cmd.rb"
load "engine/templates/ability_page_template.rb"
load "engine/templates/xp_template.rb"
load "engine/templates/sheet_page1_template.rb"
load "engine/templates/sheet_page_templates.rb"
load "engine/xp_cron_handler.rb"
load "lib/app_review.rb"
load "lib/starting_skills.rb"
load "lib/ability_point_counter.rb"
load "lib/chargen.rb"
load "lib/formatting.rb"
load "lib/luck.rb"
load "lib/parse_rolls.rb"
load "lib/ratings.rb"
load "lib/rolls.rb"
load "lib/utils.rb"
load "lib/xp.rb"
load "lib/fs3skills_api.rb"
load "lib/skills_model.rb"
load "web/skills.rb"
load "web/config_fs3skills.rb"

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
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
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