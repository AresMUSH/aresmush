$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/xp_award_cmd.rb"
load "lib/xp_costs_cmd.rb"
load "lib/xp_cron_handler.rb"
load "lib/xp_interest_cmd.rb"
load "lib/xp_lang_cmd.rb"
load "lib/xp_model.rb"
load "lib/xp_raise_cmd.rb"
load "fs3xp_api.rb"
load "templates/xp_template.rb"

module AresMUSH
  module FS3XP
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3xp", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_xp.md", "help/xp.md" ]
    end
 
    def self.config_files
      [ "config_fs3xp.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
       return nil if !cmd.root_is?("xp")
       
       case cmd.switch
       when "award"
         return XpAwardCmd         
       when "costs"
         return XpCostsCmd
       when "interest"
         return XpInterestCmd
       when "lang"
         return XpLangCmd
       when "raise"
         return XpRaiseCmd
       end
         
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end