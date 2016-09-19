$:.unshift File.dirname(__FILE__)
load "actors_interface.rb"
load "lib/actor_catcher.rb"
load "lib/actors_cmd.rb"
load "lib/actors_model.rb"
load "lib/delete_actor_cmd.rb"
load "lib/helpers.rb"
load "lib/search_actors_cmd.rb"
load "lib/set_actor_cmd.rb"
load "templates/actors_list.rb"

module AresMUSH
  module Actors
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("actors", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/actors.md", "help/admin_actors.md" ]
    end
 
    def self.config_files
      [ "config_actors.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
      return false if !cmd.root_is?("actor")
      
      case cmd.switch
      when "search"
        handler = ActorsSearchCmd.new 
      when "set"
        handler = SetActorCmd.new
      when "delete"
        handler = DeleteActorCmd.new
      when nil
        if (cmd.args)
          handler = ActorsCatcherCmd.new 
        else
          handler = ActorsListCmd.new 
        end
      else
        handler = nil
      end
      
      if (handler)
        handler.on_command(client, cmd)
        return true
      else
        return false
      end
    end

    def self.handle_event(event)
    end
  end
end