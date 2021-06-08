$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Page
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("page", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "page"
        case cmd.switch
        when "autospace"
          return PageAutospaceCmd
        when "color"
          return PageColorCmd
        when "dnd"
          return PageDoNotDisturbCmd
        when "ignore"
          return PageIgnoreCmd
        when "new" 
          return PageNewCmd
        when "review"
          if (cmd.args)
            return PageReviewCmd
          else
            return PageReviewIndexCmd
          end
        when "report"
          return PageReportCmd
        when "scan"
          return PageScanCmd
        when nil
          # It's a common mistake to type 'p' when you meant '+p' for a channel, but
          # not vice-versa.  So ignore any command that has a prefix. 
          if (!cmd.prefix)
            return PageCmd
          end
        end
      end 
          
       nil
    end
    
    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      when "CharIdledOutEvent"
        return CharIdledOutEventHandler
      end
      
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "sendPage"
        return SendPageRequestHandler
      when "markPageThreadRead"
        return MarkThreadReadRequestHandler
      when "reportPage"
        return ReportPageRequestHandler
      when "hidePageThread"
        return HidePageThreadRequestHandler
      when "setPageThreadTitle"
        return SetPageThreadTitleRequestHandler
      end
    end
    
    def self.check_config
      validator = PageConfigValidator.new
      validator.validate
    end
    
  end
end
