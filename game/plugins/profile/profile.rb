$:.unshift File.dirname(__FILE__)
load "lib/profile_add_cmd.rb"
load "lib/profile_cmd.rb"
load "lib/profile_delete_cmd.rb"
load "lib/profile_edit_cmd.rb"
load "lib/profile_model.rb"
load "templates/profile_template.rb"

module AresMUSH
  module Profile
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("profile", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
    
    def self.config_files
      [ "config_profile.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "profile"
        case cmd.switch
        when "add"
          return ProfileAddCmd
        when "delete"
          return ProfileDeleteCmd
        when "edit"
          return ProfileEditCmd
        when nil
          return ProfileCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end