$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/rank_set_cmd.rb"
load "lib/ranks_cmd.rb"
load "lib/ranks_model.rb"
load "ranks_api.rb"

module AresMUSH
  module Ranks
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("ranks", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_ranks.md", "help/ranks.md" ]
    end
 
    def self.config_files
      [ "config_ranks.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
      return nil if !cmd.root_is?("rank")
      
      case cmd.switch
      when "set"
        return RankSetCmd
      when nil
        return RanksCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
    end
  end
end