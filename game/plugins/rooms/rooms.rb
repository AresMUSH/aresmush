$:.unshift File.dirname(__FILE__)
load "lib/commands/area_cmd.rb"
load "lib/commands/build_cmd.rb"
load "lib/commands/foyer_cmd.rb"
load "lib/commands/go_cmd.rb"
load "lib/commands/grid_cmd.rb"
load "lib/commands/home_cmd.rb"
load "lib/commands/home_set_cmd.rb"
load "lib/commands/link_cmd.rb"
load "lib/commands/lock_cmd.rb"
load "lib/commands/lock_here_cmd.rb"
load "lib/commands/meetme_go_cmd.rb"
load "lib/commands/meetme_invite_cmd.rb"
load "lib/commands/open_cmd.rb"
load "lib/commands/out_cmd.rb"
load "lib/commands/rooms_cmd.rb"
load "lib/commands/roomtype_cmd.rb"
load "lib/commands/teleport_cmd.rb"
load "lib/commands/unlink_cmd.rb"
load "lib/commands/unlock_here_cmd.rb"
load "lib/helpers.rb"
load "lib/room_events.rb"
load "lib/room_model.rb"
load "rooms_interfaces.rb"

module AresMUSH
  module Rooms
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("rooms", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_getting_around.md", "help/building.md", "help/getting_around.md", "help/home.md", "help/lock.md", "help/meetme.md" ]
    end
 
    def self.config_files
      [ "config_rooms.yml" ]
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