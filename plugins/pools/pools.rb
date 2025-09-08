$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Pools
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("pools", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "pool"      
        case cmd.switch
        when "spend"
          return PoolSpendCmd    
        when "add"
          return PoolAddCmd
        when "set"
          return PoolSetCmd    
        when "reset"
          return PoolResetCmd
        when "desperate"
          return PoolDesperateCmd
        when "show"
          return PoolShowCmd        
        else
          return PoolCmd    
        end
       end
       nil
      end

    def self.get_web_request_handler(request)
      case request.cmd
      when "showPool"
        return ShowPoolRequestHandler
      when "addPool"
        return AddPoolRequestHandler
      when"spendPool"
        return SpendPoolRequestHandler
      when "resetPool"
        return ResetPoolRequestHandler
      when "desperatePool"
        return DesperatePoolRequestHandler
      end
      nil
    end
  end
end