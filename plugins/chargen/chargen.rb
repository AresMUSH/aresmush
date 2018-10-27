$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Chargen
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("chargen", "shortcuts")
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
      when "hook"
        case cmd.switch
        when "edit"
          return HooksEditCmd
        when "set"
          return HooksSetCmd
        else
          return HooksViewCmd
        end
      end
      
      return nil    
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "chargenChar"
        return ChargenCharRequestHandler
      when "chargenInfo"
        return ChargenInfoRequestHandler
      when "chargenReset"
        return ChargenResetRequestHandler
      when "chargenReview"
        return ChargenReviewRequestHandler
      when "chargenSave"
        return ChargenSaveRequestHandler
      when "chargenSubmit"
        return ChargenSubmitRequestHandler
      when "chargenUnsubmit"
        return ChargenUnsubmitRequestHandler
      when "appApprove"
        return AppApproveRequestHandler
      when "appReject"
        return AppRejectRequestHandler
      when "appReview"
        return AppReviewRequestHandler
      when "charAbilities"
        return CharAbilitiesRequestHandler
      end
      nil
    end
  end
end
