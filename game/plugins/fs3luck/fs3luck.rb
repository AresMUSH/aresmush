$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/luck_award_cmd.rb"
load "lib/luck_model.rb"
load "lib/luck_spend_cmd.rb"
load "fs3luck_api.rb"

module AresMUSH
  module FS3Luck
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3luck", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_luck.md", "help/luck.md" ]
    end
 
    def self.config_files
      [ "config_luck.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
       return nil if !cmd.root_is?("luck")
       
       case cmd.switch
       when "award"
         return LuckAwardCmd
       when "spend"
         return LuckSpendCmd
       end
       
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end