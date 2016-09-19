$:.unshift File.dirname(__FILE__)
load "friends_interface.rb"
load "lib/friend_add_cmd.rb"
load "lib/friend_note_cmd.rb"
load "lib/friend_remove_cmd.rb"
load "lib/friends_cmd.rb"
load "lib/friends_model.rb"
load "lib/helpers.rb"

module AresMUSH
  module Friends
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("friends", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/friends.md" ]
    end
 
    def self.config_files
      [ "config_friends.yml" ]
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