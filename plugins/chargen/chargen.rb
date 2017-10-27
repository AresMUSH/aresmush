$:.unshift File.dirname(__FILE__)

load "engine/app_approve_cmd.rb"
load "engine/app_cmd.rb"
load "engine/app_reject_cmd.rb"
load "engine/app_review_cmd.rb"
load "engine/app_submit_cmd.rb"
load "engine/app_unapprove_cmd.rb"
load "engine/app_unsubmit_cmd.rb"
load "engine/bg_edit_cmd.rb"
load "engine/bg_set_cmd.rb"
load "engine/bg_view_cmd.rb"
load "engine/chargen_next_prev_cmd.rb"
load "engine/chargen_start_cmd.rb"
load "engine/templates/bg_template.rb"
load "engine/templates/chargen_template.rb"
load "engine/templates/app_template.rb"
load "lib/chargen_stage_locks.rb"
load "lib/helpers.rb"
load "lib/chargen_api.rb"
load "lib/chargen_model.rb"
load 'web/controllers/chargen.rb'
load 'web/controllers/chargen_save.rb'

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