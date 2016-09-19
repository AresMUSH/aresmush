$:.unshift File.dirname(__FILE__)
load "fs3skills_interfaces.rb"
load "lib/app_review.rb"
load "lib/commands/abilities_cmd.rb"
load "lib/commands/add_hash_cmd.rb"
load "lib/commands/raise_ability_cmd.rb"
load "lib/commands/remove_hash_cmd.rb"
load "lib/commands/reset_cmd.rb"
load "lib/commands/roll_cmd.rb"
load "lib/commands/roll_opposed_cmd.rb"
load "lib/commands/set_ability_cmd.rb"
load "lib/commands/set_aptitude_cmd.rb"
load "lib/commands/set_goal_cmd.rb"
load "lib/commands/set_list_cmd.rb"
load "lib/commands/set_related_apt_cmd.rb"
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
      [ "help/abilities.md", "help/admin_skills.md", "help/goals.md", "help/relatedapt.md", "help/roll.md", "help/skills.md" ]
    end
 
    def self.config_files
      [ "config_fs3skills.yml" ]
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