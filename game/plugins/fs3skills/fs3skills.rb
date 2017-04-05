$:.unshift File.dirname(__FILE__)
load "fs3skills_api.rb"
load "lib/ability_point_counter.rb"
load "lib/app_review.rb"
load "lib/commands/abilities_cmd.rb"
load "lib/commands/add_hook_cmd.rb"
load "lib/commands/add_spec_cmd.rb"
load "lib/commands/learn_ability_cmd.rb"
load "lib/commands/raise_ability_cmd.rb"
load "lib/commands/remove_hook_cmd.rb"
load "lib/commands/remove_spec_cmd.rb"
load "lib/commands/reset_cmd.rb"
load "lib/commands/roll_cmd.rb"
load "lib/commands/roll_opposed_cmd.rb"
load "lib/commands/set_ability_cmd.rb"
load "lib/commands/xp_award_cmd.rb"
load "lib/commands/xp_cmd.rb"
load "lib/commands/luck_award_cmd.rb"
load "lib/commands/luck_spend_cmd.rb"
load "lib/commands/char_backup_command.rb"
load "lib/commands/sheet_cmd.rb"
load "lib/helpers/chargen.rb"
load "lib/helpers/formatting.rb"
load "lib/helpers/luck.rb"
load "lib/helpers/parse_rolls.rb"
load "lib/helpers/ratings.rb"
load "lib/helpers/rolls.rb"
load "lib/helpers/utils.rb"
load "lib/helpers/xp.rb"
load "lib/skills_model.rb"
load "lib/starting_skills.rb"
load "lib/ability_point_counter.rb"
load "lib/xp_cron_handler.rb"
load "templates/ability_page_template.rb"
load "templates/xp_template.rb"
load "templates/sheet_page1_template.rb"
load "templates/sheet_page_templates.rb"

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
 
    def self.help_files
      [ "help/abilities.md", "help/admin_skills.md", "help/hooks.md", "help/roll.md", "help/skills.md",
        "help/admin_luck.md", "help/luck.md", "help/backup.md", "help/sheet.md",
        "help/admin_xp.md" , "help/xp.md" ]
    end
 
    def self.config_files
      [ "config_fs3skills.yml", "config_xp.yml", "config_fs3skills_action.yml",
        "config_fs3skills_attrs.yml", "config_fs3skills_chargen.yml", 
        "config_fs3skills_langs.yml" ]
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
      when "language"
        if (cmd.switch_is?("add") || cmd.switch_is?("remove"))
          return SetLanguageCmd
        end
      when "xp"
        case cmd.switch
        when "award"
          return XpAwardCmd         
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
