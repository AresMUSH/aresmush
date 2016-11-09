$:.unshift File.dirname(__FILE__)
load "demographics_api.rb"
load "lib/age_cmd.rb"
load "lib/basic_demographic_cmd.rb"
load "lib/demographic_admin_cmd.rb"
load "lib/birthday_cmd.rb"
load "lib/demo_model.rb"
load "lib/helpers.rb"

module AresMUSH
  module Demographics
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("demographics", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/demographics.md", "help/admin_demo.md" ]
    end
 
    def self.config_files
      [ "config_demographics.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      
      case cmd.root
      when "age"
        return AgeCmd 
      when "birthdate"
        return BirthdateCmd 
      when "callsign"
        return CallsignCmd 
      when "demographic"
        case cmd.switch
        when "set"
          return DemographicAdminCmd
        end
      when "eyes"
        return EyesCmd 
      when "fullname"
        return FullnameCmd 
      when "gender"
        return GenderCmd 
      when "hair"
        return HairCmd 
      when "height"
        return HeightCmd 
      when "physique"
        return PhysiqueCmd 
      when "skin"
        return SkinCmd 
      end
      
      nil     
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end