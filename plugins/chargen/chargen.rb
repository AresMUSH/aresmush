$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Chargen
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("chargen", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
  
    def self.config_files
      [ "config_chargen.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "app"
        case cmd.switch
        when "approve"
          return AppApproveCmd 
        when "reject"
          return AppRejectCmd
        when "review"
          return AppReviewCmd
        when "submit", "confirm"
          return AppSubmitCmd
        when "unapprove"
          return AppUnapproveCmd
        when "unsubmit"
          return AppUnsubmitCmd
        when nil
          return AppCmd
        end
      when "bg"
        case cmd.switch  
        when "edit"
          return BgEditCmd 
        when "set"
          return BgSetCmd
        when nil
          return BgCmd
        end
      when "cg"
        case cmd.switch
        when "prev", "next", nil
          return ChargenPrevNextCmd 
        when "start"
          return ChargenStartCmd        
        end
      end
      
      return nil    
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end
