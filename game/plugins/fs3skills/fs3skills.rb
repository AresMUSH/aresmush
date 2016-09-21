$:.unshift File.dirname(__FILE__)
load "fs3skills_api.rb"
load "lib/app_review.rb"
load "lib/commands/abilities_cmd.rb"
load "lib/commands/add_hook_cmd.rb"
load "lib/commands/raise_ability_cmd.rb"
load "lib/commands/remove_hook_cmd.rb"
load "lib/commands/reset_cmd.rb"
load "lib/commands/roll_cmd.rb"
load "lib/commands/roll_opposed_cmd.rb"
load "lib/commands/set_ability_cmd.rb"
load "lib/commands/set_aptitude_cmd.rb"
load "lib/commands/set_goal_cmd.rb"
load "lib/helpers/chargen.rb"
load "lib/helpers/rolls.rb"
load "lib/helpers/utils.rb"
load "lib/ratings.rb"
load "lib/skills_model.rb"
load "lib/starting_skills.rb"

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
      [ "help/abilities.md", "help/admin_skills.md", "help/goals.md", "help/roll.md", "help/skills.md" ]
    end
 
    def self.config_files
      [ "config_fs3skills.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
      case cmd.root
      when "abilities"
        return AbilitiesCmd
      when "hook"
        if (cmd.switch_is?("add"))
          return AddHookCmd
        elsif (cmd.switch_is?("remove"))
          return RemoveHookCmd
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
      when "ability"
        return SetAbilityCmd
      when "aptitude"
        return SetAptitudeCmd
      when "language"
        if (cmd.switch_is?("add") || cmd.switch_is?("remove"))
          return SetLanguageCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
    end
  end
end